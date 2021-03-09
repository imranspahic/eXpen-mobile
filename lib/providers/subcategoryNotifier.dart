import 'package:expen/providers/expenseNotifier.dart';
import 'package:flutter/material.dart';
import 'package:expen/database/glavni_podaci_database.dart';

class SubcategoryModel {
  String naziv;
  String idKat;
  String idPot;
  int icon;
  Color bojaIkone;
  int mjesecnoDodavanje;
  String jeLiMjesecnoDodano;

  SubcategoryModel(
      {this.naziv,
      this.idKat,
      this.idPot,
      this.icon,
      this.bojaIkone,
      this.mjesecnoDodavanje,
      this.jeLiMjesecnoDodano});
}

class SubcategoryNotifier with ChangeNotifier {
  List<SubcategoryModel> potKategorijaLista = [];

  var ukupnoPotrosnjiUPotkategoriji = 0;

  int potKategorijePoKategoriji(String id) {
    List<SubcategoryModel> lista = [];
    lista = potKategorijaLista.where((element) => element.idKat == id).toList();
    return lista.length;
  }

  String dobijNazivPotKategorije(String idPot) {
    SubcategoryModel potKat = potKategorijaLista.singleWhere((element) {
      return element.idPot == idPot;
    }, orElse: () {
      return null;
    });
    if (potKat == null) {
      return 'Potkategorija izbrisana';
    }
    return potKat.naziv;
  }

  List<SubcategoryModel> potKategorijePoKategorijilista(String id) {
    List<SubcategoryModel> lista = [];
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

    var novaPotKategorija = SubcategoryModel(
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
    DatabaseHelper.insertPotkategorije('potkategorije', {
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
    final dataList = await DatabaseHelper.fetchTabele('potkategorije');

    potKategorijaLista = dataList.map((pk) {
      return SubcategoryModel(
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

  List<ExpenseModel> dostPotKat = [];

  void dodajUPotKatList(ExpenseModel item) {
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

  void izbrisiPotkategoriju(String id, List<ExpenseModel> listaPotrosnji) {
    potKategorijaLista.removeWhere((test) {
      return test.idPot == id;
    });
    notifyListeners();

    DatabaseHelper.izbrisiPotkategoriju('potkategorije', id);
    DatabaseHelper.izbrisiPotrosnjeuPotkategoriji('potrosnje', listaPotrosnji);
  }

  List<SubcategoryModel> get ukupnoPotkategorija {
    return potKategorijaLista;
  }

  List<SubcategoryModel> dobijdostupnePotkategorije(String idKat) {
    return potKategorijaLista.where((item) {
      return item.idKat == idKat;
    }).toList();
  }
}