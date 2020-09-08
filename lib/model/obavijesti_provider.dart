import 'package:flutter/material.dart';
import 'package:semir_potrosnja/database/glavni_podaci_database.dart';

class Obavijest {
  final String id;
  final String sadrzaj;
  final DateTime datum;
  final String idKategorije;
  final String idPotKategorije;
  String jeLiProcitano;

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

  List<Obavijest> get listaSvihObavijestiReversed {
    return listaSvihObavijesti.reversed.toList();
  }

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

    listaSvihObavijesti.add( novaObavijest);
    listaSvihObavijesti.sort((a,b) {
       return a.jeLiProcitano.compareTo(b.jeLiProcitano);
    });
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
              jeLiProcitano: obavijest['jeLiProcitano'],
            ))
        .toList();

    notifyListeners();
  }

  int neprocitaneObavijesti() {
    List<Obavijest> temp = [];

    listaSvihObavijesti.forEach((obavijest) {
      if (obavijest.jeLiProcitano == 'ne') {
        temp.add(obavijest);
      }
    });

    return temp.length;
  }

  void izbrisiObavijest(String id) {
    listaSvihObavijesti.removeWhere((item) {
      return item.id == id;
    });
    notifyListeners();
    DatabaseHelper.izbrisiPotrosnju('obavijesti', id);
  }

  void izbrisiSveObavijesti() {
    listaSvihObavijesti = [];
    notifyListeners();
    DatabaseHelper.izbrisiSveObavijesti('obavijesti');
  }
  void procitajSveObavijesti() {
    listaSvihObavijesti.forEach((obavijest) {
      obavijest.jeLiProcitano = 'da';
    });
    notifyListeners();
    DatabaseHelper.procitajSveObavijesti('obavijesti');
  }

  void procitajObavijest(String id, bool auto) {
    Obavijest obavijest = listaSvihObavijesti.singleWhere((element) => element.id == id);
    obavijest.jeLiProcitano = 'da';
     listaSvihObavijesti.sort((a,b) {
       return a.jeLiProcitano.compareTo(b.jeLiProcitano);
    });
    if(!auto) {
  notifyListeners();
    }
   
    
    DatabaseHelper.procitajObavijest('obavijesti', id);

  }

  List<Obavijest> listaNeprocitanihObavijesti() {
    List<Obavijest> temp = [];
    listaSvihObavijesti.forEach((obavijest) {
      if (obavijest.jeLiProcitano == 'ne') {
        temp.add(obavijest);
      }
    });
    return temp;
  }
}
