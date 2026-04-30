import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  static const dbName = "offline_customer.db";

  static const dbVersion = 1;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await initDb();

    return _db!;
  }

  static Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(
      path,

      version: dbVersion,

      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE customers(

id INTEGER PRIMARY KEY,

name TEXT,
phone TEXT,
email TEXT,
address TEXT,

lastVisitDate TEXT,
visitStatus TEXT,
notes TEXT,

syncStatus TEXT,
updatedAt TEXT,
lastSyncedAt TEXT

)
''');

        await db.execute('''
CREATE TABLE sync_queue(

id INTEGER PRIMARY KEY AUTOINCREMENT,

entityType TEXT,
entityId INTEGER,

operationType TEXT,
payload TEXT,

retryCount INTEGER,

createdAt TEXT,
lastAttemptAt TEXT,

syncStatus TEXT

)
''');
      },
    );
  }
}
