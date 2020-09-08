import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'pohrana_ostalo.db'),
        onCreate: (dB, version) {
      dB.execute(
          'CREATE TABLE plata(id TEXT PRIMARY KEY, godina INTEGER, mjesec TEXT, iznos REAL);');
      dB.execute(
          'CREATE TABLE rashodKategorija(idRashod TEXT PRIMARY KEY, idKat TEXT, godina INTEGER, mjesec TEXT, iznos REAL);');
    }, version: 4);
  }

  static Future<List<Map<String, dynamic>>> fetchTabele(String table) async {
    final database = await DatabaseHelper.database();
    return database.query(table);
  }

  static Future<void> dodajPlatu(
      String table, Map<String, dynamic> data) async {
    final database = await DatabaseHelper.database();
    database.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<void> updatePlatu(String table, int godina, String mjesec, double iznos) async{
    final database = await DatabaseHelper.database();
    database.update(table, {'iznos' : iznos}, where: 'godina = ? and mjesec = ?', whereArgs: [godina, mjesec]);
  }

  static Future<void> dodajRashodKategorije(
      String table, Map<String, dynamic> data) async {
    final database = await DatabaseHelper.database();
    database.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  static Future<void> updateRashodKategorije(String table, String idKat, int godina, String mjesec, double iznos) async{
    final database = await DatabaseHelper.database();
    database.update(table, {'iznos' : iznos}, where: 'godina = ? and mjesec = ? and idKat = ?', whereArgs: [godina, mjesec, idKat]);
  }

  static Future<void> izbrisiRashodKategorije(String table, String idKat) async {
    final database = await DatabaseHelper.database();
    database.delete(table, where: 'idKat = ?', whereArgs: [idKat]);
  }


  static Future<void> delete(String table) async {
    final database = await DatabaseHelper.database();
    database.delete(table);
  }

  static Future<void> dodajRashodKategorijaTabelu() async {
    final database = await DatabaseHelper.database();
    await database.execute(
          'CREATE TABLE rashodKategorija(idRashod TEXT PRIMARY KEY, idKat TEXT, godina INTEGER, mjesec TEXT, iznos REAL);');
  }
}
