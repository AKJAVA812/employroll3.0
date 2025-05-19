/*
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class SaveLatlng{
  static const _databaseNameLatlng ="SaveLatlng.db";
  static const _databaseVersionNumber= 3;
  static const tableName = 'latlngTable';

  static const id ='uniqueID';
  static const latlng ='latlng';
  static const timestamp = 'timestamp';

  late Database _dblatng;

  Future<void> init() async{
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path,_databaseNameLatlng);
    _dblatng = await openDatabase(
        path,
      version: _databaseVersionNumber,
      onCreate: _onCreatedb,
    );
  }


  Future _onCreatedb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $latlng TEXT NOT NULL,
      $timestamp TEXT NOT NULL
    )
    ''');
  }
    // Helper methods

    // Inserts a row in the database where each key in the Map is a column name
    // and the value is the column value. The return value is the id of the
    // inserted row.
  Future<int> insertlatlng(Map<String, dynamic> raw) async{
    return await _dblatng.insert(tableName, raw);
  }

  Future<List<Map<String, dynamic>>> getAllData() async{
    return await _dblatng.query(tableName);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<int> queryAllRowCount() async {
    final result = await _dblatng.rawQuery("select count('*') from $tableName");
    return Sqflite.firstIntValue(result) ?? 0;
  }
  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.

  Future<int?> updateLatlng(Map<String, dynamic> row) async{
    int idlatlng = row[id];
    return await _dblatng.update(
        tableName,
        row,
        where: '$id = ?',
        whereArgs: [idlatlng],
    );
  }
  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
*/
/*  Future<int> deleteLatlng(int id) async{
    return await _dblatng.delete(
        tableName,
        where: '$id = ?',
        whereArgs: [id],
    );
  }*//*


  Future<int> deleteLatlng(int id) async {
    return await _dblatng.delete(
      tableName, // Use actual table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

*/
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class SaveLatlng {
  static const _databaseNameLatlng = "SaveLatlng.db";
  static const _databaseVersionNumber = 3;
  static const tableName = 'latlngTable';

  static const id = 'uniqueID';  // Kept original variable name
  static const latlng = 'latlng';
  static const timestamp = 'timestamp';

  static final SaveLatlng _instance = SaveLatlng._internal();
  factory SaveLatlng() => _instance;
  SaveLatlng._internal();

  Database? _dblatng;  // Changed to nullable to avoid uninitialized error

  Future<void> init() async {
    if (_dblatng != null) return; // Prevents multiple initializations

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseNameLatlng);

    _dblatng = await openDatabase(
      path,
      version: _databaseVersionNumber,
      onCreate: _onCreatedb,
    );
  }

  Future<void> _onCreatedb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $latlng TEXT NOT NULL,
        $timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertlatlng(Map<String, dynamic> raw) async {
    final db = _dblatng!;
    return await db.insert(tableName, raw);
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = _dblatng!;
    return await db.query(tableName,limit: 50);
  }

  Future<int> queryAllRowCount() async {
    final db = _dblatng!;
    final result = await db.rawQuery("SELECT COUNT(*) FROM $tableName");
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int?> updateLatlng(Map<String, dynamic> row) async {
    final db = _dblatng!;
    int idlatlng = row[id];
    return await db.update(
      tableName,
      row,
      where: '$id = ?',
      whereArgs: [idlatlng],
    );
  }

  Future<int> deleteLatlng(int id) async {
    final db = _dblatng!;
    return await db.delete(
      tableName,
      where: '$id = ?',  // ✅ Used correct column reference
      whereArgs: [id],
    );
  }
}