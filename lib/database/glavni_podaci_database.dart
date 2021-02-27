import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

import '../model/data_provider.dart';

class DatabaseHelper {
  // OTVORI ILI NAPRAVI BAZU PODATAKA
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'nova.db'),
        onCreate: (dB, version) {
      dB.execute(
          'CREATE TABLE kategorije(id TEXT PRIMARY KEY, naziv TEXT, slikaUrl TEXT, redniBroj INTEGER, mjesecnoDodavanje INTEGER, jeLiMjesecnoDodano TEXT, Januar REAL, Februar REAL, Mart REAL, April REAL, Maj REAL, Juni REAL, Juli REAL, August REAL, Septembar REAL, Oktobar REAL, Novembar REAL, Decembar REAL)');
      dB.execute(
          'CREATE TABLE potrosnje(id TEXT PRIMARY KEY, naziv TEXT, trosak REAL, datum TEXT, nazivKategorije TEXT, idKategorije TEXT, idPotKategorije TEXT)');
      dB.execute(
          'CREATE TABLE potkategorije(idPot TEXT PRIMARY KEY, naziv TEXT, idKat TEXT, bojaIkone TEXT, icon TEXT, mjesecnoDodavanje INTEGER, jeLiMjesecnoDodano TEXT)');
      dB.execute(
          'CREATE TABLE rashodGodina(Januar REAL, Februar REAL, Mart REAL, April REAL, Maj REAL, Juni REAL, Juli REAL, August REAL, Septembar REAL, Oktobar REAL, Novembar REAL, Decembar REAL)');
      dB.execute(
          'CREATE TABLE postavke(prikazPotrosnji INTEGER, brisanjeKategorija INTEGER, zastitaLozinkom INTEGER, sifra TEXT)');
      dB.execute(
          'CREATE TABLE biljeske(id TEXT PRIMARY KEY, naziv TEXT, tekstSadrzaj TEXT, datum TEXT)');
      dB.execute(
          'CREATE TABLE planiranePotrosnje(id TEXT PRIMARY KEY, naziv TEXT, trosak REAL, datum TEXT, nazivKategorije TEXT, idKategorije TEXT, idPotKategorije TEXT)');
      dB.execute(
          'CREATE TABLE obavijesti(id TEXT PRIMARY KEY, datum TEXT, sadrzaj TEXT, idKategorije TEXT, idPotKategorije TEXT, jeLiProcitano TEXT)');
      dB.execute(
          'INSERT INTO postavke(prikazPotrosnji, brisanjeKategorija, zastitaLozinkom, sifra) VALUES(0, 1, 0, null)');
      dB.execute(
          'INSERT INTO rashodGodina(Januar, Februar, Mart, April, Maj, Juni, Juli, August, Septembar, Oktobar, Novembar, Decembar) VALUES(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)');
    }, version: 4);
  }

  static Future<void> insertKategorije(
      String table, Map<String, dynamic> data) async {
    final database = await DatabaseHelper.database();
    database.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertPotrosnje(
      String table, Map<String, dynamic> data) async {
    final database = await DatabaseHelper.database();
    database.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertPotkategorije(
      String table, Map<String, dynamic> data) async {
    final database = await DatabaseHelper.database();
    database.insert(table, data);
  }

  static Future<void> insertVisePotrosnji(
      String table,
      String nazivKategorije,
      String nazivNovi,
      int brojPotrosnji,
      double trosak,
      DateTime datum,
      String id,
      String potkategorijaId) async {
    final database = await DatabaseHelper.database();
    for (int i = 0; i < brojPotrosnji; i++) {
      database.insert(table, {
        'id': DateTime.now().toString() + i.toString(),
        'naziv': nazivNovi,
        'trosak': trosak,
        'datum': datum.toIso8601String(),
        'nazivKategorije': nazivKategorije,
        'idKategorije': id,
        'idPotKategorije': potkategorijaId,
      });
    }
  }

  static Future<List<Map<String, dynamic>>> fetchTabele(String table) async {
    final database = await DatabaseHelper.database();
    return database.query(table);
  }

  static Future<void> izbrisiKategoriju(String table, String id) async {
    final database = await DatabaseHelper.database();
    database.delete(table, where: 'id = ?', whereArgs: [id]);
    //alternative better
    // database.rawDelete('DELETE FROM kategorije WHERE id = $id');
    //raw queries nauceno..
  }

  static Future<void> izbrisiPotrosnjeuKategoriji(
      String table, List<PotrosnjaModel> lista) async {
    final database = await DatabaseHelper.database();
    lista.forEach((element) {
      database.delete(table, where: 'id = ?', whereArgs: [element.id]);
    });
  }

  static Future<void> izbrisiPotkategorijeuKategoriji(
      String table, List<PotKategorija> lista) async {
    final database = await DatabaseHelper.database();
    lista.forEach((element) {
      database.delete(table, where: 'idPot= ?', whereArgs: [element.idPot]);
    });
  }

  static Future<void> izbrisiPotrosnjeuPotkategoriji(
      String table, List<PotrosnjaModel> lista) async {
    final database = await DatabaseHelper.database();
    lista.forEach((element) {
      database.delete(table, where: 'id= ?', whereArgs: [element.id]);
    });
  }

  static Future<void> izbrisiPotrosnju(String table, String id) async {
    final database = await DatabaseHelper.database();
    database.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> izbrisiPotkategoriju(String table, String idPot) async {
    final database = await DatabaseHelper.database();
    database.delete(table, where: 'idPot = ?', whereArgs: [idPot]);
  }

  static Future<void> updateRashodKategorije(
      String table, String idKat, String mjesec, double value) async {
    final database = await DatabaseHelper.database();
    database.update(table, {mjesec: value},
        where: "id = ?", whereArgs: [idKat]);
  }

  static Future<void> updatePotkategoriju(
      String table, String idPot, String s, String i, String naziv) async {
    final database = await DatabaseHelper.database();
    database.update(table, {'bojaIkone': s, 'icon': i, 'naziv': naziv},
        where: 'idPot = ?', whereArgs: [idPot]);
  }

  static Future<void> updateRashodUkupnoGodina(
      String table, String key, double value) async {
    final database = await DatabaseHelper.database();
    database.update(table, {key: value});
  }

  static Future<void> updatePostavke(
      String table, String key, int value) async {
    final database = await DatabaseHelper.database();
    database.update(table, {key: value});
  }

  static Future<void> updateSifru(
      String table, String key, String value) async {
    final database = await DatabaseHelper.database();
    database.update(table, {key: value});
  }

  static Future<void> updateKategoriju(
      String table, String key, String value, String id) async {
    final database = await DatabaseHelper.database();
    database.update(table, {key: value}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateRedniBrojKategorije(
      String table, int redniBroj, String id) async {
    final database = await DatabaseHelper.database();
    database.update(table, {'redniBroj': redniBroj},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateMjesecnoDodavanje(
    String table,
    int mjesecnoDodavanje,
    String id,
  ) async {
    final database = await DatabaseHelper.database();
    database.update(table, {'mjesecnoDodavanje': mjesecnoDodavanje},
        where: table == 'kategorije' ? 'id = ?' : 'idPot = ?', whereArgs: [id]);
  }

  static Future<void> updateJeLiMjesecnoDodano(
      String table, String vrijednost, String id) async {
    final database = await DatabaseHelper.database();
    database.update(table, {'jeLiMjesecnoDodano': vrijednost},
        where: table == 'kategorije' ? 'id = ?' : 'idPot = ?', whereArgs: [id]);
  }

  static Future<void> insertBiljeske(
      String table, Map<String, dynamic> data) async {
    final database = await DatabaseHelper.database();
    database.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> izbrisiBiljesku(String table, String id) async {
    final database = await DatabaseHelper.database();
    database.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> insertObavijest(
      String table, Map<String, dynamic> data) async {
    final database = await DatabaseHelper.database();
    database.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> procitajObavijest(String table, String id) async {
    final database = await DatabaseHelper.database();
    database.update(table, {'jeLiProcitano': 'da'},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> izbrisiSveObavijesti(String table) async {
    final database = await DatabaseHelper.database();
    database.delete(table);
  }

  static Future<void> procitajSveObavijesti(String table) async {
    final database = await DatabaseHelper.database();
    database.update(table, {'jeLiProcitano': 'da'});
  }

  static Future<void> updateSlikePathFix(String table, String path) async {
    final database = await DatabaseHelper.database();
    database.update(table, {'slikaUrl': path});
  }

  static Future<void> addDBColumnFix(String table) async {
    final database = await DatabaseHelper.database();
    await database.execute('ALTER TABLE $table ADD COLUMN redniBroj INTEGER;');
    final dataList = await fetchTabele(table);
    for (int i = 1; i <= dataList.length; i++) {
      database.update(table, {'redniBroj': i},
          where: 'id = ?', whereArgs: [dataList[i - 1]['id']]);
    }
  }

  static Future<void> dodajTabeluBiljeske() async {
    final database = await DatabaseHelper.database();
    await database.execute(
        'CREATE TABLE biljeske (id TEXT PRIMARY KEY, naziv TEXT, tekstSadrzaj TEXT, datum TEXT);');
  }

  static Future<void> dodajTabeluPlaniranePotrosnje() async {
    final database = await DatabaseHelper.database();
    await database.execute(
        'CREATE TABLE planiranePotrosnje(id TEXT PRIMARY KEY, naziv TEXT, trosak REAL, datum TEXT, nazivKategorije TEXT, idKategorije TEXT, idPotKategorije TEXT);');
  }

  static Future<void> dodajColumnMjesecnoDodavanje(String table) async {
    final database = await DatabaseHelper.database();
    await database
        .execute('ALTER TABLE $table ADD COLUMN mjesecnoDodavanje INTEGER;');
    await database
        .execute('ALTER TABLE $table ADD COLUMN jeLiMjesecnoDodano TEXT;');
    database.update(table, {'mjesecnoDodavanje': 1});
    database.update(table, {'jeLiMjesecnoDodano': 'ne'});
  }

  static Future<void> dodajTabeluObavijesti() async {
    final database = await DatabaseHelper.database();
    await database.execute(
        'CREATE TABLE obavijesti(id TEXT PRIMARY KEY, datum TEXT, sadrzaj TEXT, idKategorije TEXT, idPotKategorije TEXT, jeLiProcitano TEXT)');
  }

  static Future<void> dodajColumnMjesecnoDodavanjePotkategorije(
      String table) async {
    final database = await DatabaseHelper.database();
    await database
        .execute('ALTER TABLE $table ADD COLUMN mjesecnoDodavanje INTEGER;');
    await database
        .execute('ALTER TABLE $table ADD COLUMN jeLiMjesecnoDodano TEXT;');
    database.update(table, {'mjesecnoDodavanje': 1});
    database.update(table, {'jeLiMjesecnoDodano': 'ne'});
  }

  static Future<void> updateCategoryTableIconColor() async {
    final database = await DatabaseHelper.database();
    await database
        .execute('ALTER TABLE kategorije ADD COLUMN ikonaPotrošnji TEXT;');
    await database.execute(
        'ALTER TABLE kategorije ADD COLUMN prikažiIkonuPotrošnje TEXT DEFAULT "NE";');
  }
}

Future<Database> database() async {
  final dbPath = await sql.getDatabasesPath();
  return sql.openDatabase(path.join(dbPath, 'nova.db'),
      onCreate: (dB, version) {
    dB.execute(
        'CREATE TABLE biljeske(id TEXT PRIMARY KEY, naziv TEXT, tekstSadrzaj TEXT, datum TEXT)');
  }, version: 4);
}

Future<void> insertBiljeske(String table, Map<String, dynamic> data) async {
  final database = await DatabaseHelper.database();
  database.insert(
    table,
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
