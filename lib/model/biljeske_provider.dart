import 'package:flutter/material.dart';
import 'package:semir_potrosnja/database/kategorija_database.dart';

class Biljeska {
  final String id;
  final String naziv;
  final String tekstSadrzaj;
  final DateTime datum;

  Biljeska(
      {@required this.id,
      @required this.naziv,
      @required this.tekstSadrzaj,
      this.datum});
}

class BiljeskeLista extends ChangeNotifier {
  List<Biljeska> listaBiljeski = [];

  void dodajBiljesku(String naziv, String tekstSadrzaj, DateTime datum) {
    final novaBiljeska = Biljeska(
        id: DateTime.now().toString(),
        naziv: naziv,
        tekstSadrzaj: tekstSadrzaj,
        datum: datum);
    listaBiljeski.add(novaBiljeska);
    notifyListeners();
    DatabaseHelper.insertBiljeske('biljeske', {
      'id': novaBiljeska.id,
      'naziv': novaBiljeska.naziv,
      'tekstSadrzaj': novaBiljeska.tekstSadrzaj,
      'datum': novaBiljeska.datum.toIso8601String(),
    });
  }

  Future<void> fetchAndSetBiljeske() async {
    final dataList = await DatabaseHelper.fetchTabele('biljeske');

    listaBiljeski = dataList
        .map((b) => Biljeska(
              id: b['id'],
              naziv: b['naziv'],
              tekstSadrzaj: b['tekstSadrzaj'],
              datum: DateTime.parse(b['datum']),
            ))
        .toList();

    notifyListeners();
  }

  void izbrisiBiljesku(String id) {
    listaBiljeski.removeWhere((element) => element.id == id);
    notifyListeners();
    DatabaseHelper.izbrisiBiljesku('biljeske', id);
  }
}
