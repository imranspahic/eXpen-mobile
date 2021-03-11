import 'package:flutter/material.dart';
import 'package:expen/database/glavni_podaci_database.dart';

class NoteModel {
  final String id;
  final String naziv;
  final String tekstSadrzaj;
  final DateTime datum;

  NoteModel(
      {@required this.id,
      @required this.naziv,
      @required this.tekstSadrzaj,
      this.datum});
}

class NoteNotifier extends ChangeNotifier {
  List<NoteModel> listaBiljeski = [];

  void dodajBiljesku(String naziv, String tekstSadrzaj, DateTime datum) {
    final novaBiljeska = NoteModel(
        id: DateTime.now().toString(),
        naziv: naziv,
        tekstSadrzaj: tekstSadrzaj,
        datum: datum);
    listaBiljeski.add(novaBiljeska);
    notifyListeners();
    DatabaseHelper.insertRowIntoTable('biljeske', {
      'id': novaBiljeska.id,
      'naziv': novaBiljeska.naziv,
      'tekstSadrzaj': novaBiljeska.tekstSadrzaj,
      'datum': novaBiljeska.datum.toIso8601String(),
    });
  }

  Future<void> fetchAndSetBiljeske() async {
    final dataList = await DatabaseHelper.fetchTable('biljeske');

    listaBiljeski = dataList
        .map((b) => NoteModel(
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
    DatabaseHelper.delereRowFromTable('biljeske', id);
  }
}
