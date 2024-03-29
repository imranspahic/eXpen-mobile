import 'dart:convert';
import 'package:expen/models/Expense.dart';
import 'package:expen/models/Subcategory.dart';
import 'package:expen/services/settingsServices/profileServices.dart';
import '../database/rashod_plata_database.dart' as rpDB;
import 'package:expen/database/glavni_podaci_database.dart';
import 'package:flutter/material.dart';
import 'package:expen/models/Category.dart';

class CategoryNotifier with ChangeNotifier {
  CategoryNotifier._internal();
  static final CategoryNotifier _instance = CategoryNotifier._internal();
  factory CategoryNotifier() => _instance;

  List<Category> kategorijaLista = [];

  String dobijNazivKategorije(String idKat) {
    Category kat = kategorijaLista.singleWhere((element) {
      return element.id == idKat;
    }, orElse: () {
      return null;
    });
    if (kat == null) {
      return 'Kategorija izbrisana';
    }
    return kat.naziv;
  }

  double uk;
  void rashodMjesec(double first, double second) {
    uk = first - second;
  }

  void dodajRashod(String key, double value, String idKat) {
    final kategorija =
        kategorijaLista.singleWhere((element) => element.id == idKat);
    kategorija.mapaRashoda[key] = value;
    notifyListeners();
    DatabaseHelper.updateRashodKategorije('kategorije', idKat, key, value);
  }

  void dodajKategoriju(String nazivNovi, int redniBroj) {
    var novaKategorija = Category(
      naziv: nazivNovi,
      id: DateTime.now().toString(),
      mapaRashoda: {
        'Januar': 0.0,
        'Februar': 0.0,
        'Mart': 0.0,
        'April': 0.0,
        'Maj': 0.0,
        'Juni': 0.0,
        'Juli': 0.0,
        'August': 0.0,
        'Septembar': 0.0,
        'Oktobar': 0.0,
        'Novembar': 0.0,
        'Decembar': 0.0,
      },
      isExpanded: false,
      slikaUrl: 'assets/images/nema-slike.jpg',
      redniBroj: redniBroj,
      mjesecnoDodavanje: 1,
      jeLiMjesecnoDodano: 'ne',
    );

    kategorijaLista.add(novaKategorija);
    notifyListeners();
    DatabaseHelper.insertRowIntoTable('kategorije', {
      'id': novaKategorija.id,
      'naziv': novaKategorija.naziv,
      'slikaUrl': novaKategorija.slikaUrl,
      'redniBroj': redniBroj,
      'mjesecnoDodavanje': 1,
      'jeLiMjesecnoDodano': 'ne',
      'Januar': 0.0,
      'Februar': 0.0,
      'Mart': 0.0,
      'April': 0.0,
      'Maj': 0.0,
      'Juni': 0.0,
      'Juli': 0.0,
      'August': 0.0,
      'Septembar': 0.0,
      'Oktobar': 0.0,
      'Novembar': 0.0,
      'Decembar': 0.0,
    });
  }

  Future<void> fetchAndSetKategorije(BuildContext context) async {
    final dataList = await DatabaseHelper.fetchTable('kategorije');

    List<Category> s = [];
    dataList.forEach((e) {
      s.add(Category(
          naziv: e['naziv'],
          id: e['id'],
          slikaUrl: e['slikaUrl'],
          slikaEncoded: e['slikaUrl'] == 'assets/images/nema-slike.jpg'
              ? null
              : base64Decode(e['slikaUrl']),
          redniBroj: e['redniBroj'],
          mjesecnoDodavanje: e['mjesecnoDodavanje'],
          jeLiMjesecnoDodano: e['jeLiMjesecnoDodano'],
          mapaRashoda: {
            'Januar': e['Januar'],
            'Februar': e['Februar'],
            'Mart': e['Mart'],
            'April': e['April'],
            'Maj': e['Maj'],
            'Juni': e['Juni'],
            'Juli': e['Juli'],
            'August': e['August'],
            'Septembar': e['Septembar'],
            'Oktobar': e['Oktobar'],
            'Novembar': e['Novembar'],
            'Decembar': e['Decembar']
          }));
    });

    kategorijaLista = s;
    kategorijaLista.sort((a, b) {
      return a.redniBroj.compareTo(b.redniBroj);
    });

    ProfileServices.getProfileState(context);

    notifyListeners();
  }

  void izbrisiKategoriju(String id, List<Expense> listaPotrosnji,
      List<Subcategory> listaPotkategorija) {
    kategorijaLista.removeWhere((item) {
      return item.id == id;
    });

    notifyListeners();
    DatabaseHelper.delereRowFromTable('kategorije', id);
    DatabaseHelper.deleteExpensesFromTable('potrosnje', listaPotrosnji);
    DatabaseHelper.izbrisiPotkategorijeuKategoriji(
        'potkategorije', listaPotkategorija);
    rpDB.DatabaseHelper.izbrisiRashodKategorije('rashodKategorija', id);
  }

  void updateSlikuKategorije(String slikaPath, String id) {
    Category kategorija =
        kategorijaLista.singleWhere((element) => element.id == id);
    kategorija.slikaUrl = slikaPath;
    kategorija.slikaEncoded = base64Decode(slikaPath);
    notifyListeners();
    DatabaseHelper.updateKategoriju('kategorije', 'slikaUrl', slikaPath, id);
  }

  void updateRedniBrojKategorije(int redniBroj, String id) {
    kategorijaLista.singleWhere((element) => element.id == id).redniBroj =
        redniBroj;
    DatabaseHelper.updateRedniBrojKategorije('kategorije', redniBroj, id);
    notifyListeners();
  }

  void updateMjesecnoDodavanjeKategorije(String id, int mjesecnoDodavanje) {
    kategorijaLista
        .singleWhere((element) => element.id == id)
        .mjesecnoDodavanje = mjesecnoDodavanje;
    DatabaseHelper.updateMjesecnoDodavanje('kategorije', mjesecnoDodavanje, id);
    notifyListeners();
  }

  Category dobijKategorijuPoId(String id) {
    return kategorijaLista.singleWhere((element) => element.id == id);
  }

  void updateNazivKategorije(String naziv, String id) {
    Category kategorija =
        kategorijaLista.singleWhere((element) => element.id == id);
    kategorija.naziv = naziv;
    notifyListeners();
    DatabaseHelper.updateKategoriju('kategorije', 'naziv', naziv, id);
  }
}
