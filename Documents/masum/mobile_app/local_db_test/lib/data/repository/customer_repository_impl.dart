import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../local/customer_local_ds.dart';
import '../local/sync_local_ds.dart';
import '../models/customer_model.dart';
import '../remote/customer_remote_ds.dart';

class CustomerRepository {
  final local = CustomerLocalDataSource();
  final remote = CustomerRemoteDataSource();
  final sync = SyncLocalDataSource();

  // Always read from local DB. Try fetching from server to keep data fresh,
  // but never overwrite records that have pending offline changes.
  Future<List<CustomerModel>> loadCustomers() async {
    try {
      final remoteData = await remote.fetchCustomers();
      await local.insertCustomers(remoteData); // Safe: skips pending records
    } catch (e) {
      // Offline or server error — local data is the source of truth
      debugPrint('fetchCustomers failed: $e');
    }
    return await local.getCustomers();
  }

  // Update a customer's visit status and notes (offline-first)
  Future<void> updateCustomer(CustomerModel customer) async {
    customer.syncStatus = 'pending_update';
    customer.updatedAt = DateTime.now().toIso8601String();
    await local.updateCustomer(customer);

    await sync.addQueueItem({
      'entityType': 'customer',
      'entityId': customer.id,
      'operationType': 'update',
      'payload': jsonEncode(customer.toMap()),
      'retryCount': 0,
      'createdAt': DateTime.now().toIso8601String(),
      'lastAttemptAt': '',
      'syncStatus': 'pending',
    });
  }

  // Log a new visit for an existing customer (offline-first)
  Future<void> createVisit({
    required int customerId,
    required String status,
    required String notes,
  }) async {
    // 1. Update customer locally with new visit info
    final customer = await local.getCustomerById(customerId);
    if (customer == null) return;

    customer.visitStatus = status;
    customer.notes = notes;
    customer.lastVisitDate = DateTime.now().toIso8601String();
    customer.syncStatus = 'pending_create';
    customer.updatedAt = DateTime.now().toIso8601String();
    await local.updateCustomer(customer);

    // 2. Queue POST /visits for when we go online
    await sync.addQueueItem({
      'entityType': 'visit',
      'entityId': customerId,
      'operationType': 'create',
      'payload': jsonEncode({
        'customerId': customerId,
        'visitDate': DateTime.now().toIso8601String(),
        'status': status,
        'notes': notes,
      }),
      'retryCount': 0,
      'createdAt': DateTime.now().toIso8601String(),
      'lastAttemptAt': '',
      'syncStatus': 'pending',
    });
  }

  Future<int> getPendingCount() async {
    return await sync.getPendingCount();
  }
}
