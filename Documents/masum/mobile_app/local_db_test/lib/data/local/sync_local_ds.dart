import 'package:local_db_test/database/datahase_helper.dart';

class SyncLocalDataSource {
  Future<void> addQueueItem(Map<String, dynamic> data) async {
    final db = await DatabaseHelper.database;
    await db.insert('sync_queue', data);
  }

  Future<List<Map<String, dynamic>>> getPending() async {
    final db = await DatabaseHelper.database;
    return await db.query(
      'sync_queue',
      where: 'syncStatus = ?',
      whereArgs: ['pending'],
    );
  }

  Future<int> getPendingCount() async {
    final db = await DatabaseHelper.database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM sync_queue WHERE syncStatus = 'pending'",
    );
    return result.first['count'] as int;
  }

  Future<void> markSynced(int id) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'sync_queue',
      {'syncStatus': 'synced'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateRetry({required int id, required int retryCount}) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'sync_queue',
      {
        'retryCount': retryCount,
        'lastAttemptAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markFailed(int id) async {
    final db = await DatabaseHelper.database;
    await db.update(
      'sync_queue',
      {'syncStatus': 'failed'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
