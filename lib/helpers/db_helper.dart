import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'expenses.db'), 
      onCreate: (db, version) => 
        db.execute("""CREATE TABLE transactions(
                                  id INTEGER PRIMARY KEY NOT NULL, 
                                  type INTEGER NOT NULL, 
                                  amount REAL NOT NULL, 
                                  date TEXT NOT NULL, 
                                  description TEXT)
      """)
    , version: 1);
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table, orderBy: "id DESC");
  }
}