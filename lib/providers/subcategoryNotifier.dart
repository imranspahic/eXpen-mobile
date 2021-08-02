import 'package:expen/models/Category.dart';
import 'package:expen/models/Expense.dart';
import 'package:flutter/material.dart';
import 'package:expen/database/glavni_podaci_database.dart';
import 'package:expen/models/Subcategory.dart';

class SubcategoryNotifier with ChangeNotifier {
  List<Subcategory> potKategorijaLista = [];

  List<Subcategory> _subcategoriesByCategory = [];
  List<Subcategory> get subcategoriesByCategory => _subcategoriesByCategory;

  void setSubcategoriesByCategory(Category category) =>
      _subcategoriesByCategory = potKategorijaLista
          .where((Subcategory subcategory) => subcategory.idKat == category.id)
          .toList();

  var ukupnoPotrosnjiUPotkategoriji = 0;

  int potKategorijePoKategoriji(String id) {
    List<Subcategory> lista = [];
    lista = potKategorijaLista.where((element) => element.idKat == id).toList();
    return lista.length;
  }

  String dobijNazivPotKategorije(String idPot) {
    Subcategory potKat = potKategorijaLista.singleWhere((element) {
      return element.idPot == idPot;
    }, orElse: () {
      return null;
    });
    if (potKat == null) {
      return 'Potkategorija izbrisana';
    }
    return potKat.naziv;
  }

  List<Subcategory> potKategorijePoKategorijilista(String id) {
    List<Subcategory> lista = [];
    lista = potKategorijaLista.where((element) => element.idKat == id).toList();
    return lista;
  }

  String potKategorijaPoId(String id) {
    if (id == 'nemaPotkategorija') {
      return 'Nema potkategorije';
    } else {
      return potKategorijaLista
          .singleWhere((element) => element.idPot == id)
          .naziv;
    }
  }

  void dodajPotKategoriju(String nazivNovi, String idKat) {
    int val = Colors.grey.value;

    var novaPotKategorija = Subcategory(
      naziv: nazivNovi,
      idKat: idKat,
      idPot: DateTime.now().toString(),
      icon: 58055,
      bojaIkone: Color(val),
      mjesecnoDodavanje: 1,
      jeLiMjesecnoDodano: 'ne',
    );

    potKategorijaLista.add(novaPotKategorija);
    notifyListeners();
    DatabaseHelper.insertRowIntoTable('potkategorije', {
      'idPot': novaPotKategorija.idPot,
      'naziv': novaPotKategorija.naziv,
      'idKat': novaPotKategorija.idKat,
      'bojaIkone': novaPotKategorija.bojaIkone
          .toString()
          .substring(6, 16), //(35,45 - emulator)
      'icon': novaPotKategorija.icon,
      'mjesecnoDodavanje': 1,
      'jeLiMjesecnoDodano': 'ne',
    });
  }

  Future<void> fetchAndSetPotkategorije() async {
    final dataList = await DatabaseHelper.fetchTable('potkategorije');

    potKategorijaLista = dataList.map((pk) {
      return Subcategory(
        naziv: pk['naziv'],
        idKat: pk['idKat'],
        idPot: pk['idPot'],
        bojaIkone: Color(int.parse(pk['bojaIkone'])),
        icon: int.parse(pk['icon']),
        mjesecnoDodavanje: pk['mjesecnoDodavanje'],
        jeLiMjesecnoDodano: pk['jeLiMjesecnoDodano'],
      );
    }).toList();

    notifyListeners();
  }

  void snimiPromjene(String idPot, String naziv, Color boja, String icon) {
    String s;
    int val = boja.value;
    s = Color(val).toString().substring(6, 16);

    DatabaseHelper.updatePotkategoriju('potkategorije', idPot, s, icon, naziv);
  }

  int ukupnePotrosnjeUPotkategoriji = 0;

  List<Expense> dostPotKat = [];

  void dodajUPotKatList(Expense item) {
    if (dostPotKat.contains(item)) {
      return;
    } else {
      dostPotKat.add(item);
    }
  }

  void updateMjesecnoDodavanjePotkategorije(
      String idPot, int mjesecnoDodavanje) {
    potKategorijaLista
        .singleWhere((element) => element.idPot == idPot)
        .mjesecnoDodavanje = mjesecnoDodavanje;
    DatabaseHelper.updateMjesecnoDodavanje(
        'potkategorije', mjesecnoDodavanje, idPot);
    notifyListeners();
  }

  void izbrisiPotkategoriju(String id, List<Expense> listaPotrosnji) {
    potKategorijaLista.removeWhere((test) {
      return test.idPot == id;
    });
    notifyListeners();

    DatabaseHelper.izbrisiPotkategoriju('potkategorije', id);
    DatabaseHelper.deleteExpensesFromTable('potrosnje', listaPotrosnji);
  }

  List<Subcategory> get ukupnoPotkategorija {
    return potKategorijaLista;
  }

  List<Subcategory> xdobijdostupnePotkategorije(String idKat) {
    return potKategorijaLista.where((item) {
      return item.idKat == idKat;
    }).toList();
  }
}
