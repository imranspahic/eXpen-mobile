import 'package:expen/models/Category.dart';
import 'package:expen/models/Expense.dart';
import 'package:flutter/material.dart';
import 'package:expen/database/glavni_podaci_database.dart';

class ExpenseNotifier with ChangeNotifier {
  List<Expense> expenses = [];
  List<Expense> plannedExpenses = [];

  ///Expenses in category without subcategory
  List<Expense> _expensesByCategory = [];
  List<Expense> get expensesByCategory => _expensesByCategory;

  void setExpensesByCategory(Category category) =>
      _expensesByCategory = expenses
          .where((Expense expense) =>
              expense.idKategorije == category.id &&
              expense.idPotKategorije == "nemaPotkategorija")
          .toList();

  void izbrisiPotrosnju(String id) {
    expenses.removeWhere((item) {
      return item.id == id;
    });
    notifyListeners();
    DatabaseHelper.delereRowFromTable('potrosnje', id);
  }

  int potrosnjePoKategoriji(String katId) {
    List<Expense> lista = [];
    lista = expenses
        .where((element) => element.idKategorije == katId)
        .toList();
    return lista.length;
  }

  double trosakPoKategoriji(String katId) {
    List<Expense> lista = [];
    lista = expenses
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
    expenses.forEach((element) {
      trosak = trosak + element.trosak;
    });
    return trosak;
  }

  List<Expense> potrosnjePoKategorijilista(String katId) {
    List<Expense> lista = [];
    lista = expenses
        .where((element) => element.idKategorije == katId)
        .toList();
    return lista;
  }

  List<Expense> potrosnjePoPotkaategorijilista(String potKatId) {
    List<Expense> lista = [];
    lista = expenses
        .where((element) => element.idPotKategorije == potKatId)
        .toList();
    return lista;
  }

  double trosakPotrosnjiPoMjesecuKategorije(String katId, int mjesec) {
    List<Expense> temp = [];
    List<Expense> listaPot = [];
    double ukupniTrosak = 0.0;
    expenses.forEach((potrosnja) {
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
    final novaPotrosnja = Expense(
      id: DateTime.now().toString(),
      naziv: nazivNovi,
      trosak: trosak,
      datum: datum,
      nazivKategorije: nazivKategorije,
      idKategorije: id,
      idPotKategorije: potkategorijaId,
    );

    expenses.add(novaPotrosnja);

    //sortiraj liste po datumu od najveceg ka najmanjem
    expenses.sort((a, b) => -a.datum.compareTo(b.datum));

    notifyListeners();
    DatabaseHelper.insertRowIntoTable('potrosnje', {
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
    print("fetching potrosnje");
    final dataList = await DatabaseHelper.fetchTable('potrosnje');

    expenses = dataList
        .map((p) => Expense(
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
    final dataList = await DatabaseHelper.fetchTable('planiranePotrosnje');
    plannedExpenses = dataList
        .map((p) => Expense(
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
    final novaPlaniranaPotrosnja = Expense(
      id: DateTime.now().toString(),
      naziv: nazivNovi,
      trosak: trosak,
      nazivKategorije: nazivKategorije,
      idKategorije: id,
      idPotKategorije: potkategorijaId,
    );

    plannedExpenses.add(novaPlaniranaPotrosnja);

    //sortiraj liste po datumu od najveceg ka najmanjem
    // plannedExpenses.sort((a, b) => -a.datum.compareTo(b.datum));

    notifyListeners();
    DatabaseHelper.insertRowIntoTable('planiranePotrosnje', {
      'id': novaPlaniranaPotrosnja.id,
      'naziv': novaPlaniranaPotrosnja.naziv,
      'trosak': novaPlaniranaPotrosnja.trosak,
      // 'datum': novaPotrosnja.datum.toIso8601String(),
      'nazivKategorije': novaPlaniranaPotrosnja.nazivKategorije,
      'idKategorije': novaPlaniranaPotrosnja.idKategorije,
      'idPotKategorije': novaPlaniranaPotrosnja.idPotKategorije,
    });
  }

  List<Expense> dobijPlaniranePotrosnjeKategorije(String katId) {
    List<Expense> tempList;
    tempList = plannedExpenses.where((item) {
      return item.idKategorije == katId &&
          item.idPotKategorije == 'nemaPotkategorija';
    }).toList();

    return tempList;
  }

  List<Expense> dobijPlaniranePotrosnjePotkategorije(
      String katId, String potId) {
    List<Expense> tempList;
    tempList = plannedExpenses.where((item) {
      return item.idKategorije == katId && item.idPotKategorije == potId;
    }).toList();

    return tempList;
  }

  void izbrisiPlaniranuPotrosnju(String id) {
    plannedExpenses.removeWhere((item) {
      return item.id == id;
    });
    notifyListeners();
    DatabaseHelper.delereRowFromTable('planiranePotrosnje', id);
  }

  Future<List<Map<String, dynamic>>>
      provjeriMjesecnoDodavanjeKategorija() async {
    //lista kategorija
    final dataListKategorije = await DatabaseHelper.fetchTable('kategorije');

    //lista planiranihPotrosnji
    final dataListPlaniranePotrosnje =
        await DatabaseHelper.fetchTable('planiranePotrosnje');

    //lista potkategorija
    final dataListPotkategorije =
        await DatabaseHelper.fetchTable('potkategorije');

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
            List<Expense> potrosnje = [];
            potrosnje = listaPotrosnjiZaDodat.map((potrosnja) {
              return Expense(
                id: potrosnja['id'],
                naziv: potrosnja['naziv'],
                trosak: potrosnja['trosak'],
                nazivKategorije: potrosnja['nazivKategorije'],
                idKategorije: potrosnja['idKategorije'],
                idPotKategorije: potrosnja['idPotKategorije'],
                datum: datumDanasnji,
              );
            }).toList();
            // if(expenses.any((potrosnja)  {
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
              expenses.add(potrosnje[i]);

              DatabaseHelper.insertRowIntoTable('potrosnje', {
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
            List<Expense> potrosnje = [];
            potrosnje = listaPotrosnjiZaDodat.map((potrosnja) {
              return Expense(
                id: potrosnja['id'],
                naziv: potrosnja['naziv'],
                trosak: potrosnja['trosak'],
                nazivKategorije: potrosnja['nazivKategorije'],
                idKategorije: potrosnja['idKategorije'],
                idPotKategorije: potrosnja['idPotKategorije'],
                datum: datumDanasnji,
              );
            }).toList();
            // if(expenses.any((potrosnja)  {
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
              expenses.add(potrosnje[i]);

              DatabaseHelper.insertRowIntoTable('potrosnje', {
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

  List<Expense> dostupnePotrosnje = [];
  void dobijDostupnePotrosnje(List<Expense> dostupnePotrosnje) {
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
      final novaPotrosnja = Expense(
        id: DateTime.now().toString() + i.toString(),
        naziv: nazivNovi,
        trosak: trosak,
        datum: datum,
        nazivKategorije: nazivKategorije,
        idKategorije: id,
        idPotKategorije: potkategorijaId,
      );

      expenses.add(novaPotrosnja);
      //sortiraj liste po datumu od najveceg ka najmanjem
      expenses.sort((a, b) => -a.datum.compareTo(b.datum));
      notifyListeners();
    }
    DatabaseHelper.insertMultipleExpenses('potrosnje', nazivKategorije,
        nazivNovi, brojPotrosnji, trosak, datum, id, potkategorijaId);
  }

  List<Expense> get ukupnoPotrosnji {
    return expenses;
  }

  String badge(String idPot) {
    List<Expense> s = [];
    s = expenses.where((test) {
      return test.idPotKategorije == idPot;
    }).toList();

    return s.length.toString();
  }
}
