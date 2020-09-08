import 'package:flutter/material.dart';
import '../database/rashod_plata_database.dart';

class Plata {
  final String id;
  int godina;
  String mjesec;
  double iznos;

  Plata({
    this.id,
    this.godina,
    this.mjesec,
    this.iznos,
  });
}

class PlataLista extends ChangeNotifier {
  List<Plata> listaPlate = [];
  

  void dodajPlatu(String mjesec, double iznos) {
    final DateTime datumDanasnji = DateTime.now();
    if (listaPlate.any((plata) {
      print(plata.mjesec);
      if (plata.godina == datumDanasnji.year && plata.mjesec == mjesec) {
        return true;
      } else {
        return false;
      }
    })) {
      //update

      Plata plata = listaPlate.singleWhere((plata) {
        if (plata.godina == datumDanasnji.year && plata.mjesec == mjesec) {
          return true;
        } else {
          return false;
        }
      });

      plata.iznos = iznos;
      notifyListeners();
      DatabaseHelper.updatePlatu('plata', datumDanasnji.year, mjesec, iznos);
      return;
    } else {
      final novaPlata = Plata(
        id: DateTime.now().toString(),
        godina: DateTime.now().year,
        mjesec: mjesec,
        iznos: iznos,
      );

      listaPlate.add(novaPlata);
      notifyListeners();
      DatabaseHelper.dodajPlatu('plata', {
        'id': novaPlata.id,
        'godina': novaPlata.godina,
        'mjesec': novaPlata.mjesec,
        'iznos': novaPlata.iznos,
      });
    }
  }

  void izbrisi() {
    DatabaseHelper.delete('plata');
  }

  Future<void> fetchAndSetPlata() async {
    final dataList = await DatabaseHelper.fetchTabele('plata');
    listaPlate = dataList.map((plata) {
      return Plata(
        id: plata['id'],
        godina: plata['godina'],
        mjesec: plata['mjesec'],
        iznos: plata['iznos'],
      );
    }).toList();

    notifyListeners();
  }

  double dobijPlatuPoMjesecu(String mjesec) {
    DateTime datumDanasnji = DateTime.now();

    Plata plata = listaPlate.singleWhere((plata) {
      if(plata.godina == datumDanasnji.year && plata.mjesec == mjesec) {
       
        return true;
      }
      else {
       
        return false;
      }
    }, orElse: () {
      
      return null;
    });
    if(plata==null) {
      return 0.0;
    }
    else {
      return plata.iznos;
    }
  }
}
