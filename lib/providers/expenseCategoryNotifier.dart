import 'package:flutter/material.dart';
import '../database/rashod_plata_database.dart';

//Preimenovano iz RashodKategorija

class ExpenseCategoryModel {
  final String idRashod;
  final String idKat;
  int godina;
  String mjesec;
  double iznos;

  ExpenseCategoryModel({
    this.idRashod,
    this.idKat,
    this.godina,
    this.mjesec,
    this.iznos,
  });
}

class ExpenseCategoryNotifier extends ChangeNotifier {
  List<ExpenseCategoryModel> listaRashoda = [];

  void dodajRashodKategorije(String idKat, String mjesec, double iznos) {
    final DateTime datumDanasnji = DateTime.now();
    List<ExpenseCategoryModel> listaRashodaPoKategoriji = [];

    if (listaRashoda.isNotEmpty) {
      listaRashoda.forEach((rashod) {
        if (rashod.idKat == idKat) {
          listaRashodaPoKategoriji.add(rashod);
        }
      });
    }

    if (listaRashodaPoKategoriji.any((rashod) {
      print(rashod.mjesec);
      if (rashod.godina == datumDanasnji.year && rashod.mjesec == mjesec) {
        return true;
      } else {
        return false;
      }
    })) {
      //update

      ExpenseCategoryModel rashod =
          listaRashodaPoKategoriji.singleWhere((rashod) {
        if (rashod.godina == datumDanasnji.year && rashod.mjesec == mjesec) {
          return true;
        } else {
          return false;
        }
      });

      rashod.iznos = iznos;
      notifyListeners();
      DatabaseHelper.updateRashodKategorije(
          'rashodKategorija', idKat, datumDanasnji.year, mjesec, iznos);
      return;
    } else {
      final noviRashod = ExpenseCategoryModel(
        idRashod: DateTime.now().toString(),
        idKat: idKat,
        godina: DateTime.now().year,
        mjesec: mjesec,
        iznos: iznos,
      );

      listaRashoda.add(noviRashod);
      notifyListeners();
      DatabaseHelper.dodajRashodKategorije('rashodKategorija', {
        'idRashod': noviRashod.idRashod,
        'idKat': noviRashod.idKat,
        'godina': noviRashod.godina,
        'mjesec': noviRashod.mjesec,
        'iznos': noviRashod.iznos,
      });
    }
  }

  Future<void> fetchAndSetRashodKategorija() async {
    final dataList = await DatabaseHelper.fetchTabele('rashodKategorija');
    print(dataList);
    listaRashoda = dataList.map((rashod) {
      return ExpenseCategoryModel(
        idRashod: rashod['idRashod'],
        idKat: rashod['idKat'],
        godina: rashod['godina'],
        mjesec: rashod['mjesec'],
        iznos: rashod['iznos'],
      );
    }).toList();

    notifyListeners();
  }

  double dobijRashodKategorijePoMjesecu(String idKat, String mjesec) {
    DateTime datumDanasnji = DateTime.now();

    List<ExpenseCategoryModel> listaRashodaPoKategoriji = [];

    if (listaRashoda.isNotEmpty) {
      listaRashoda.forEach((rashod) {
        if (rashod.idKat == idKat) {
          listaRashodaPoKategoriji.add(rashod);
        }
      });
    }

    ExpenseCategoryModel rashod =
        listaRashodaPoKategoriji.singleWhere((rashod) {
      if (rashod.godina == datumDanasnji.year && rashod.mjesec == mjesec) {
        return true;
      } else {
        return false;
      }
    }, orElse: () {
      return null;
    });
    if (rashod == null) {
      return 0.0;
    } else {
      return rashod.iznos;
    }
  }

  double dobijRashodSvihKategorijaPoMjesecu(String mjesec) {
    final datumDanasnji = DateTime.now();

    List<ExpenseCategoryModel> listaZaDodat = [];
    double iznos = 0.0;
    listaRashoda.forEach((rashod) {
      if (rashod.godina == datumDanasnji.year && rashod.mjesec == mjesec) {
        listaZaDodat.add(rashod);
      }
    });

    listaZaDodat.forEach((rashod) {
      iznos = iznos + rashod.iznos;
    });
    return iznos;
  }
}
