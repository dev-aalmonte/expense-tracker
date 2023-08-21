import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'expenses.db'),
        onCreate: (db, version) {
      db.execute("""CREATE TABLE transactions(
                                  id INTEGER PRIMARY KEY NOT NULL, 
                                  account_id INTEGER NOT NULL,
                                  type INTEGER NOT NULL,
                                  amount REAL NOT NULL, 
                                  date TEXT NOT NULL,
                                  category INTEGER,
                                  description TEXT)
        """);
      db.execute("""CREATE TABLE user_card(
                                  id INTEGER PRIMARY KEY NOT NULL, 
                                  total REAL NOT NULL, 
                                  spent REAL NOT NULL)
        """);
      db.execute("""CREATE TABLE accounts(
                                  id INTEGER PRIMARY KEY NOT NULL, 
                                  name TEXT NOT NULL,
                                  acc_number TEXT NOT NULL UNIQUE,
                                  available REAL NOT NULL, 
                                  spent REAL NOT NULL)
        """);
    }, version: 4);
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table, orderBy: "id DESC");
  }

  static Future<List<Map<String, dynamic>>> fetchWhere(
      String table, String column, var value) async {
    final db = await DBHelper.database();
    return db.query(table, where: '$column = ?', whereArgs: [value]);
  }

  static Future<List<Map<String, dynamic>>> fetchWhereBetween(
      String table, String column, List range) async {
    final db = await DBHelper.database();
    return db.query(table, where: '$column BETWEEN ? AND ?', whereArgs: range);
  }

  static Future<void> clearData() async {
    final dbPath = await sql.getDatabasesPath();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    sql.deleteDatabase(path.join(dbPath, 'expenses.db'));
    prefs.remove('deposit');
    prefs.remove('spent');
  }
}
