import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:local_db_test/core/constant.dart';

import '../../data/local/sync_local_ds.dart';
import '../../data/local/customer_local_ds.dart';

class SyncService {
  final syncDs = SyncLocalDataSource();
  final customerDs = CustomerLocalDataSource();
  final Dio dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  bool isSyncing = false;

  Future<void> syncPendingData() async {
    if (isSyncing) return;
    isSyncing = true;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isConnected = connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.ethernet);

      if (!isConnected) {
        isSyncing = false;
        return;
      }

      final pendingItems = await syncDs.getPending();
      for (var item in pendingItems) {
        await _processItem(item);
      }
    } catch (e) {
      debugPrint('Sync error: $e');
    }

    isSyncing = false;
  }

  Future<void> _processItem(Map<String, dynamic> item) async {
    try {
      final payload = jsonDecode(item['payload']) as Map<String, dynamic>;
      final operation = item['operationType'] as String;

      if (operation == 'create') {
        // POST /visits — payload has customerId, visitDate, status, notes
        await dio.post('/visits', data: payload);
        await _markCustomerSyncedById(payload['customerId'] as int?);
      } else if (operation == 'update') {
        // PUT /customers/{id}/visit-status — payload is full customer object
        // PATCH /customers/:id — partial update, works with json-server v1
        await dio.patch('/customers/${payload['id']}', data: {
          'visitStatus': payload['visitStatus'],
          'notes': payload['notes'],
          'lastVisitDate': payload['lastVisitDate'],
        });
        await _markCustomerSyncedById(payload['id'] as int?);
      }

      await syncDs.markSynced(item['id'] as int);
    } catch (e) {
      debugPrint('Item sync failed: $e');
      await _markFailed(item);
    }
  }

  // Look up customer by ID and mark as synced — works for both create and update
  Future<void> _markCustomerSyncedById(int? customerId) async {
    if (customerId == null) return;
    final customer = await customerDs.getCustomerById(customerId);
    if (customer == null) return;
    customer.syncStatus = 'synced';
    customer.lastSyncedAt = DateTime.now().toIso8601String();
    await customerDs.updateCustomer(customer);
  }

  Future<void> _markFailed(Map<String, dynamic> item) async {
    int retry = (item['retryCount'] as int?) ?? 0;
    retry++;

    if (retry >= AppConstants.maxRetries) {
      await syncDs.markFailed(item['id'] as int);
    } else {
      await syncDs.updateRetry(id: item['id'] as int, retryCount: retry);
    }
  }
}
