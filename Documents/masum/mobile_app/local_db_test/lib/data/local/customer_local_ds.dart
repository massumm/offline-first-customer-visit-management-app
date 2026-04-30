import 'package:local_db_test/database/datahase_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../models/customer_model.dart';

class CustomerLocalDataSource {
  // BUG FIX: Don't overwrite records that have pending local changes.
  // If a user updated a customer offline, we must not erase that with old server data.
  Future<void> insertCustomers(List<CustomerModel> customers) async {
    final db = await DatabaseHelper.database;

    for (var c in customers) {
      final existing = await db.query(
        'customers',
        where: 'id = ?',
        whereArgs: [c.id],
      );

      if (existing.isNotEmpty) {
        final localStatus = existing.first['syncStatus'] as String;
        // Skip this record — it has local changes waiting to sync
        if (localStatus == 'pending_update' || localStatus == 'pending_create') {
          continue;
        }
      }

      c.syncStatus = 'synced';
      await db.insert(
        'customers',
        c.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<CustomerModel>> getCustomers() async {
    final db = await DatabaseHelper.database;
    final result = await db.query('customers', orderBy: 'name ASC');
    return result.map((e) => CustomerModel.fromJson(e)).toList();
  }

  Future<CustomerModel?> getCustomerById(int id) async {
    final db = await DatabaseHelper.database;
    final result = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return CustomerModel.fromJson(result.first);
  }

  Future<void> insertCustomer(CustomerModel customer) async {
    final db = await DatabaseHelper.database;
    await db.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> getPendingCount() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM customers WHERE syncStatus != 'synced'",
    );
    return result.first['count'] as int;
  }
}
