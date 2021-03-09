import 'package:expen/providers/categoryNotifier.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:expen/database/glavni_podaci_database.dart';

class ExpenseModel extends CategoryNotifier {
  String id;
  String naziv;
  double trosak;
  DateTime datum;
  String nazivKategorije;
  String idKategorije;
  String idPotKategorije;

  String getIndex(int row, int i) {
    switch (i) {
      case 0:
        return (row + 1).toString();
        break;
      case 1:
        return this.naziv;
        break;
      case 2:
        return this.trosak.toString();
        break;
      case 3:
        return DateFormat('dd. MM. yyyy.').format(this.datum);
        break;
      case 4:
        return this.nazivKategorije;
        break;
      default:
        return '';
    }
  }

  ExpenseModel(
      {@required this.id,
      @required this.naziv,
      @required this.trosak,
      this.datum,
      this.nazivKategorije,
      this.idKategorije,
      this.idPotKategorije});
}

class ExpenseNotifier with ChangeNotifier {
  List<ExpenseModel> listaSvihPotrosnji = [];
  List<ExpenseModel> listaPlaniranihPotrosnji = [];

  void izbrisiPotrosnju(String id) {
    listaSvihPotrosnji.removeWhere((item) {
      return item.id == id;
    });
    notifyListeners();
    DatabaseHelper.izbrisiPotrosnju('potrosnje', id);
  }

  int potrosnjePoKategoriji(String katId) {
    List<ExpenseModel> lista = [];
    lista = listaSvihPotrosnji
        .where((element) => element.idKategorije == katId)
        .toList();
    return lista.length;
  }

  double trosakPoKategoriji(String katId) {
    List<ExpenseModel> lista = [];
    lista = listaSvihPotrosnji
        .where((element) => element.idKategorije == katId)
        .toList();
    double ukupno = 0.0;
    lista.forEach((element) {
      ukupno = ukupno + element.trosak;
    });
    return ukupno;
  }

  double ukupniTrosakSvihPotrosnji() {
    double trosak = 0.0;
    listaSvihPotrosnji.forEach((element) {
      trosak = trosak + element.trosak;
    });
    return trosak;
  }

  List<ExpenseModel> potrosnjePoKategorijilista(String katId) {
    List<ExpenseModel> lista = [];
    lista = listaSvihPotrosnji
        .where((element) => element.idKategorije == katId)
        .toList();
    return lista;
  }

  List<ExpenseModel> potrosnjePoPotkaategorijilista(String potKatId) {
    List<ExpenseModel> lista = [];
    lista = listaSvihPotrosnji
        .where((element) => element.idPotKategorije == potKatId)
        .toList();
    return lista;
  }

  double trosakPotrosnjiPoMjesecuKategorije(String katId, int mjesec) {
    List<ExpenseModel> temp = [];
    List<ExpenseModel> listaPot = [];
    double ukupniTrosak = 0.0;
    listaSvihPotrosnji.forEach((potrosnja) {
      if (potrosnja.idKategorije == katId) {
        temp.add(potrosnja);
      }
    });
    temp.forEach((potrosnja) {
      if (potrosnja.datum.month == mjesec) {
        listaPot.add(potrosnja);
      }
    });

    listaPot.forEach((potrosnja) {
      ukupniTrosak = ukupniTrosak + potrosnja.trosak;
    });

    return ukupniTrosak;
  }

  void dodajPotrosnju(String nazivKategorije, String nazivNovi, double trosak,
      DateTime datum, String id, String potkategorijaId) {
    final novaPotrosnja = ExpenseModel(
      id: DateTime.now().toString(),
      naziv: nazivNovi,
      trosak: trosak,
      datum: datum,
      nazivKategorije: nazivKategorije,
      idKategorije: id,
      idPotKategorije: potkategorijaId,
    );

    listaSvihPotrosnji.add(novaPotrosnja);

    //sortiraj liste po datumu od najveceg ka najmanjem
    listaSvihPotrosnji.sort((a, b) => -a.datum.compareTo(b.datum));

    notifyListeners();
    DatabaseHelper.insertPotrosnje('potrosnje', {
      'id': novaPotrosnja.id,
      'naziv': novaPotrosnja.naziv,
      'trosak': novaPotrosnja.trosak,
      'datum': novaPotrosnja.datum.toIso8601String(),
      'nazivKategorije': novaPotrosnja.nazivKategorije,
      'idKategorije': novaPotrosnja.idKategorije,
      'idPotKategorije': novaPotrosnja.idPotKategorije,
    });
  }

  Future<void> fetchAndSetPotrosnje() async {
    final dataList = await DatabaseHelper.fetchTabele('potrosnje');

    listaSvihPotrosnji = dataList
        .map((p) => ExpenseModel(
              id: p['id'],
              naziv: p['naziv'],
              trosak: p['trosak'],
              datum: DateTime.parse(p['datum']),
              nazivKategorije: p['nazivKategorije'],
              idKategorije: p['idKategorije'],
              idPotKategorije: p['idPotKategorije'],
            ))
        .toList();

    notifyListeners();
  }

  Future<void> fetchAndSetPlaniranePotrosnje() async {
    final dataList = await DatabaseHelper.fetchTabele('planiranePotrosnje');
    listaPlaniranihPotrosnji = dataList
        .map((p) => ExpenseModel(
              id: p['id'],
              naziv: p['naziv'],
              trosak: p['trosak'],
              nazivKategorije: p['nazivKategorije'],
              idKategorije: p['idKategorije'],
              idPotKategorije: p['idPotKategorije'],
            ))
        .toList();

    notifyListeners();
  }

  void dodajPlaniranuPotrosnju(String nazivKategorije, String nazivNovi,
      double trosak, String id, String potkategorijaId) {
    final novaPlaniranaPotrosnja = ExpenseModel(
      id: DateTime.now().toString(),
      naziv: nazivNovi,
      trosak: trosak,
      nazivKategorije: nazivKategorije,
      idKategorije: id,
      idPotKategorije: potkategorijaId,
    );

    listaPlaniranihPotrosnji.add(novaPlaniranaPotrosnja);

    //sortiraj liste po datumu od najveceg ka najmanjem
    // listaPlaniranihPotrosnji.sort((a, b) => -a.datum.compareTo(b.datum));

    notifyListeners();
    DatabaseHelper.insertPotrosnje('planiranePotrosnje', {
      'id': novaPlaniranaPotrosnja.id,
      'naziv': novaPlaniranaPotrosnja.naziv,
      'trosak': novaPlaniranaPotrosnja.trosak,
      // 'datum': novaPotrosnja.datum.toIso8601String(),
      'nazivKategorije': novaPlaniranaPotrosnja.nazivKategorije,
      'idKategorije': novaPlaniranaPotrosnja.idKategorije,
      'idPotKategorije': novaPlaniranaPotrosnja.idPotKategorije,
    });
  }

  List<ExpenseModel> dobijPlaniranePotrosnjeKategorije(String katId) {
    List<ExpenseModel> tempList;
    tempList = listaPlaniranihPotrosnji.where((item) {
      return item.idKategorije == katId &&
          item.idPotKategorije == 'nemaPotkategorija';
    }).toList();

    return tempList;
  }

  List<ExpenseModel> dobijPlaniranePotrosnjePotkategorije(
      String katId, String potId) {
    List<ExpenseModel> tempList;
    tempList = listaPlaniranihPotrosnji.where((item) {
      return item.idKategorije == katId && item.idPotKategorije == potId;
    }).toList();

    return tempList;
  }

  void izbrisiPlaniranuPotrosnju(String id) {
    listaPlaniranihPotrosnji.removeWhere((item) {
      return item.id == id;
    });
    notifyListeners();
    DatabaseHelper.izbrisiPotrosnju('planiranePotrosnje', id);
  }

  Future<List<Map<String, dynamic>>>
      provjeriMjesecnoDodavanjeKategorija() async {
    //lista kategorija
    final dataListKategorije = await DatabaseHelper.fetchTabele('kategorije');

    //lista planiranihPotrosnji
    final dataListPlaniranePotrosnje =
        await DatabaseHelper.fetchTabele('planiranePotrosnje');

    //lista potkategorija
    final dataListPotkategorije =
        await DatabaseHelper.fetchTabele('potkategorije');

    await fetchAndSetPotrosnje();

    final datumDanasnji = DateTime.now();

    List<Map<String, dynamic>> listaObavijesti = [];

    if (dataListKategorije.isNotEmpty) {
      dataListKategorije.forEach((kategorija) {
        if (kategorija['mjesecnoDodavanje'] == datumDanasnji.day) {
          print('Kategorija ${kategorija['naziv']}: jednako');
          List<Map<String, dynamic>> listaPotrosnjiZaDodat = [];
          listaPotrosnjiZaDodat = dataListPlaniranePotrosnje.where((potrosnja) {
            return potrosnja['idKategorije'] == kategorija['id'];
          }).toList();
          print(listaPotrosnjiZaDodat);
          if (listaPotrosnjiZaDodat.isNotEmpty) {
            List<ExpenseModel> potrosnje = [];
            potrosnje = listaPotrosnjiZaDodat.map((potrosnja) {
              return ExpenseModel(
                id: potrosnja['id'],
                naziv: potrosnja['naziv'],
                trosak: potrosnja['trosak'],
                nazivKategorije: potrosnja['nazivKategorije'],
                idKategorije: potrosnja['idKategorije'],
                idPotKategorije: potrosnja['idPotKategorije'],
                datum: datumDanasnji,
              );
            }).toList();
            // if(listaSvihPotrosnji.any((potrosnja)  {
            //   return potrosnja.id == potrosnje[0].id;
            // })) {
            //   print('Već dodano');
            //   return;

            // }

            //provjeriti jesu li već dodane!

            if (kategorija['jeLiMjesecnoDodano'] == 'da') {
              print('Već dodano');
              return;
            }

            //provjeriti jeLidansutra
            if (datumDanasnji.day > kategorija['mjesecnoDodavanje'] ||
                datumDanasnji.day < kategorija['mjesecnoDodavanje']) {
              DatabaseHelper.updateJeLiMjesecnoDodano(
                  'kategorije', 'ne', kategorija['id']);
            }

            for (int i = 0; i < potrosnje.length; i++) {
              listaSvihPotrosnji.add(potrosnje[i]);

              DatabaseHelper.insertPotrosnje('potrosnje', {
                'id':
                    '${potrosnje[i].id}/$i/${datumDanasnji.second}/${datumDanasnji.millisecond}',
                'naziv': potrosnje[i].naziv,
                'trosak': potrosnje[i].trosak,
                'datum': potrosnje[i].datum.toIso8601String(),
                'nazivKategorije': potrosnje[i].nazivKategorije,
                'idKategorije': potrosnje[i].idKategorije,
                'idPotKategorije': potrosnje[i].idPotKategorije,
              });
            }

            DatabaseHelper.updateJeLiMjesecnoDodano(
                'kategorije', 'da', kategorija['id']);
            notifyListeners();
            print(
                'Planirane potrosnje za kategoriju ${kategorija['naziv']} dodane');

            //OBAVIJEST DODANA
            Map<String, dynamic> podaciObavijesti = {
              'imaObavijest': false,
              'sadrzaj': '',
              'datum': null,
              'idKategorije': null,
              'idPotKategorije': null,
              'jeLiProcitano': 'ne',
            };
            print('kategorija id za dodavanje u obavijest ${kategorija['id']}');
            podaciObavijesti['imaObavijest'] = true;
            podaciObavijesti['sadrzaj'] =
                'Dodane potrošnje za kategoriju ${kategorija['naziv']} na osnovu mjesečnog dodavanja. Broj dodanih potrošnji: ${potrosnje.length}';
            podaciObavijesti['datum'] = datumDanasnji;
            podaciObavijesti['idKategorije'] = kategorija['id'];
            podaciObavijesti['idPotKategorije'] = 'nemaPotkategorija';

            listaObavijesti.add(podaciObavijesti);
          }
        } else {
          print('Kategorija ${kategorija['naziv']}: nije jednako');
        }
      });
    } //provjera za kategorije

    if (dataListPotkategorije.isNotEmpty) {
      dataListPotkategorije.forEach((potkategorija) {
        if (potkategorija['mjesecnoDodavanje'] == datumDanasnji.day) {
          print('Potkategorija ${potkategorija['naziv']}: jednako');
          List<Map<String, dynamic>> listaPotrosnjiZaDodat = [];
          listaPotrosnjiZaDodat = dataListPlaniranePotrosnje.where((potrosnja) {
            return potrosnja['idPotKategorije'] == potkategorija['idPot'];
          }).toList();
          print(listaPotrosnjiZaDodat);
          if (listaPotrosnjiZaDodat.isNotEmpty) {
            List<ExpenseModel> potrosnje = [];
            potrosnje = listaPotrosnjiZaDodat.map((potrosnja) {
              return ExpenseModel(
                id: potrosnja['id'],
                naziv: potrosnja['naziv'],
                trosak: potrosnja['trosak'],
                nazivKategorije: potrosnja['nazivKategorije'],
                idKategorije: potrosnja['idKategorije'],
                idPotKategorije: potrosnja['idPotKategorije'],
                datum: datumDanasnji,
              );
            }).toList();
            // if(listaSvihPotrosnji.any((potrosnja)  {
            //   return potrosnja.id == potrosnje[0].id;
            // })) {
            //   print('Već dodano');
            //   return;

            // }

            //provjeriti jesu li već dodane!

            if (potkategorija['jeLiMjesecnoDodano'] == 'da') {
              print('Već dodano');
              return;
            }

            //provjeriti jeLidansutra
            if (datumDanasnji.day > potkategorija['mjesecnoDodavanje'] ||
                datumDanasnji.day < potkategorija['mjesecnoDodavanje']) {
              DatabaseHelper.updateJeLiMjesecnoDodano(
                  'potkategorije', 'ne', potkategorija['idPot']);
            }

            for (int i = 0; i < potrosnje.length; i++) {
              listaSvihPotrosnji.add(potrosnje[i]);

              DatabaseHelper.insertPotrosnje('potrosnje', {
                'id':
                    '${potrosnje[i].id}/$i/${datumDanasnji.second}/${datumDanasnji.millisecond}',
                'naziv': potrosnje[i].naziv,
                'trosak': potrosnje[i].trosak,
                'datum': potrosnje[i].datum.toIso8601String(),
                'nazivKategorije': potrosnje[i].nazivKategorije,
                'idKategorije': potrosnje[i].idKategorije,
                'idPotKategorije': potrosnje[i].idPotKategorije,
              });
            }

            DatabaseHelper.updateJeLiMjesecnoDodano(
                'potkategorije', 'da', potkategorija['idPot']);
            notifyListeners();
            print(
                'Planirane potrosnje za potkategoriju ${potkategorija['naziv']} dodane');

            //OBAVIJEST DODANA
            Map<String, dynamic> podaciObavijesti = {
              'imaObavijest': false,
              'sadrzaj': '',
              'datum': null,
              'idKategorije': null,
              'idPotKategorije': null,
              'jeLiProcitano': 'ne',
            };

            podaciObavijesti['imaObavijest'] = true;
            podaciObavijesti['sadrzaj'] =
                'Dodane potrošnje za potkategoriju ${potkategorija['naziv']} na osnovu mjesečnog dodavanja. Broj dodanih potrošnji: ${potrosnje.length}';
            podaciObavijesti['datum'] = datumDanasnji;
            podaciObavijesti['idKategorije'] = potkategorija['idKat'];
            podaciObavijesti['idPotKategorije'] = potkategorija['idPot'];

            listaObavijesti.add(podaciObavijesti);
          }
        } else {
          print('Kategorija ${potkategorija['naziv']}: nije jednako');
        }
      });
    }

    //provjera za potkategorije
    return listaObavijesti;
  }

  List<ExpenseModel> dostupnePotrosnje = [];
  void dobijDostupnePotrosnje(List<ExpenseModel> dostupnePotrosnje) {
    dostupnePotrosnje = dostupnePotrosnje;
  }

  void dodajVisePotrosnji(
      String nazivKategorije,
      String nazivNovi,
      int brojPotrosnji,
      double trosak,
      DateTime datum,
      String id,
      String potkategorijaId) {
    for (int i = 0; i < brojPotrosnji; i++) {
      final novaPotrosnja = ExpenseModel(
        id: DateTime.now().toString() + i.toString(),
        naziv: nazivNovi,
        trosak: trosak,
        datum: datum,
        nazivKategorije: nazivKategorije,
        idKategorije: id,
        idPotKategorije: potkategorijaId,
      );

      listaSvihPotrosnji.add(novaPotrosnja);
      //sortiraj liste po datumu od najveceg ka najmanjem
      listaSvihPotrosnji.sort((a, b) => -a.datum.compareTo(b.datum));
      notifyListeners();
    }
    DatabaseHelper.insertVisePotrosnji('potrosnje', nazivKategorije, nazivNovi,
        brojPotrosnji, trosak, datum, id, potkategorijaId);
  }

  List<ExpenseModel> get ukupnoPotrosnji {
    return listaSvihPotrosnji;
  }

  List<ExpenseModel> dobijdostupnePotrosnje(String katId) {
    List<ExpenseModel> tempList;
    tempList = listaSvihPotrosnji.where((item) {
      return item.idKategorije == katId &&
          item.idPotKategorije == 'nemaPotkategorija';
    }).toList();
    tempList.sort((a, b) {
      return -a.datum.compareTo(b.datum);
    });
    return tempList;
  }

  String badge(String idPot) {
    List<ExpenseModel> s = [];
    s = listaSvihPotrosnji.where((test) {
      return test.idPotKategorije == idPot;
    }).toList();

    return s.length.toString();
  }
}
