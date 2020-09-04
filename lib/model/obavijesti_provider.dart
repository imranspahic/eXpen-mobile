import 'package:flutter/material.dart';
import 'package:semir_potrosnja/database/kategorija_database.dart';

class Obavijest {
  final String id;
  final String sadrzaj;
  final DateTime datum;
  final String idKategorije;
  final String idPotKategorije;
  final String jeLiProcitano;

  Obavijest({
    this.id,
    this.sadrzaj,
    this.datum,
    this.idKategorije,
    this.idPotKategorije,
    this.jeLiProcitano,
  });
}

class ObavijestiLista extends ChangeNotifier {
  List<Obavijest> listaSvihObavijesti = [];

  void dodajObavijest(String sadrzaj, DateTime datum, String idKategorije,
      String idPotkategorije, String jeLiProcitano) {
    final Obavijest novaObavijest = Obavijest(
      id: DateTime.now().toString(),
      sadrzaj: sadrzaj,
      datum: datum,
      idKategorije: idKategorije,
      idPotKategorije: idPotkategorije,
      jeLiProcitano: jeLiProcitano,
    );

    listaSvihObavijesti.insert(0,novaObavijest);
    notifyListeners();
    DatabaseHelper.insertObavijest('obavijesti', {
      'id': novaObavijest.id,
      'sadrzaj': novaObavijest.sadrzaj,
      'datum': novaObavijest.datum.toIso8601String(),
      'idKategorije': novaObavijest.idKategorije,
      'idPotKategorije': novaObavijest.idPotKategorije,
      'jeLiProcitano': novaObavijest.jeLiProcitano,
    });
  }

  Future<void> fetchAndSetObavijesti() async {
    final dataList = await DatabaseHelper.fetchTabele('obavijesti');
    listaSvihObavijesti = dataList
        .map((obavijest) => Obavijest(
              id: obavijest['id'],
              sadrzaj: obavijest['sadrzaj'],
              datum: DateTime.parse(obavijest['datum']),
              idKategorije: obavijest['idKategorije'],
              idPotKategorije: obavijest['idPotKategorije'],
            ))
        .toList();

    notifyListeners();
  }
}
