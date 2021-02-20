import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../database/glavni_podaci_database.dart';
import '../database/rashod_plata_database.dart' as rpDB;
import 'package:intl/intl.dart';
import 'dart:convert';

// POTROŠNJA MODEL

class PotrosnjaModel extends KategorijaLista {
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

  PotrosnjaModel(
      {@required this.id,
      @required this.naziv,
      @required this.trosak,
      this.datum,
      this.nazivKategorije,
      this.idKategorije,
      this.idPotKategorije});
}

class PotrosnjaLista with ChangeNotifier {
  List<PotrosnjaModel> listaSvihPotrosnji = [];
  List<PotrosnjaModel> listaPlaniranihPotrosnji = [];

  void izbrisiPotrosnju(String id) {
    listaSvihPotrosnji.removeWhere((item) {
      return item.id == id;
    });
    notifyListeners();
    DatabaseHelper.izbrisiPotrosnju('potrosnje', id);
  }

  int potrosnjePoKategoriji(String katId) {
    List<PotrosnjaModel> lista = [];
    lista = listaSvihPotrosnji
        .where((element) => element.idKategorije == katId)
        .toList();
    return lista.length;
  }

  double trosakPoKategoriji(String katId) {
    List<PotrosnjaModel> lista = [];
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

  List<PotrosnjaModel> potrosnjePoKategorijilista(String katId) {
    List<PotrosnjaModel> lista = [];
    lista = listaSvihPotrosnji
        .where((element) => element.idKategorije == katId)
        .toList();
    return lista;
  }

  List<PotrosnjaModel> potrosnjePoPotkaategorijilista(String potKatId) {
    List<PotrosnjaModel> lista = [];
    lista = listaSvihPotrosnji
        .where((element) => element.idPotKategorije == potKatId)
        .toList();
    return lista;
  }

  double trosakPotrosnjiPoMjesecuKategorije(String katId, int mjesec) {
    List<PotrosnjaModel> temp = [];
    List<PotrosnjaModel> listaPot = [];
    double ukupniTrosak = 0.0;
    listaSvihPotrosnji.forEach((potrosnja) {
      if(potrosnja.idKategorije == katId) {
        temp.add(potrosnja);
      }
    });
    temp.forEach((potrosnja) {
      if(potrosnja.datum.month == mjesec) {
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
    final novaPotrosnja = PotrosnjaModel(
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
        .map((p) => PotrosnjaModel(
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
        .map((p) => PotrosnjaModel(
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
    final novaPlaniranaPotrosnja = PotrosnjaModel(
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

  List<PotrosnjaModel> dobijPlaniranePotrosnjeKategorije(String katId) {
    List<PotrosnjaModel> tempList;
    tempList = listaPlaniranihPotrosnji.where((item) {
      return item.idKategorije == katId &&
          item.idPotKategorije == 'nemaPotkategorija';
    }).toList();

    return tempList;
  }

  List<PotrosnjaModel> dobijPlaniranePotrosnjePotkategorije(
      String katId, String potId) {
    List<PotrosnjaModel> tempList;
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
            List<PotrosnjaModel> potrosnje = [];
            potrosnje = listaPotrosnjiZaDodat.map((potrosnja) {
              return PotrosnjaModel(
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
            List<PotrosnjaModel> potrosnje = [];
            potrosnje = listaPotrosnjiZaDodat.map((potrosnja) {
              return PotrosnjaModel(
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

  List<PotrosnjaModel> dostupnePotrosnje = [];
  void dobijDostupnePotrosnje(List<PotrosnjaModel> dostupnePotrosnje) {
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
      final novaPotrosnja = PotrosnjaModel(
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

  List<PotrosnjaModel> get ukupnoPotrosnji {
    return listaSvihPotrosnji;
  }

  List<PotrosnjaModel> dobijdostupnePotrosnje(String katId) {
    List<PotrosnjaModel> tempList;
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
    List<PotrosnjaModel> s = [];
    s = listaSvihPotrosnji.where((test) {
      return test.idPotKategorije == idPot;
    }).toList();

    return s.length.toString();
  }
}

// KATEGORIJA MODEL

class KategorijaModel {
  String id;
  String naziv;
  Color bojaPozadine;
  String slikaUrl;
  Map<String, double> mapaRashoda;
  bool isExpanded;
  Uint8List slikaEncoded;
  int redniBroj;
  int mjesecnoDodavanje;
  String jeLiMjesecnoDodano;

  KategorijaModel({
    @required this.naziv,
    this.bojaPozadine,
    this.id,
    this.slikaUrl,
    this.mapaRashoda,
    this.isExpanded = false,
    this.slikaEncoded,
    this.redniBroj,
    this.mjesecnoDodavanje,
    this.jeLiMjesecnoDodano,
  });
}

class KategorijaLista with ChangeNotifier {
  List<KategorijaModel> kategorijaLista = [
    // KategorijaModel(
    //   naziv: 'Imran',
    //   bojaPozadine: Colors.green,
    //   slikaUrl: 'assets/images/imran.jpeg',
    //   rashodGodina: 0,
    //   mapaRashoda: {
    //     'Januar': 0.0,
    //     'Februar': 0.0,
    //     'Mart': 0.0,
    //     'April': 0.0,
    //     'Maj': 0.0,
    //     'Juni': 0.0,
    //     'Juli': 0.0,
    //     'August': 0.0,
    //     'Septembar': 0.0,
    //     'Oktobar': 0.0,
    //     'Novembar': 0.0,
    //     'Decembar': 0.0,
    //   },
    //   isExpanded: false
    // ),
  ];

  String dobijNazivKategorije(String idKat) {
    KategorijaModel kat = kategorijaLista.singleWhere((element) {
      return element.id == idKat;
    }, orElse: () {
      return null;
    });
    if (kat == null) {
      return 'Kategorija izbrisana';
    }
    return kat.naziv;
  }

  double uk;
  void rashodMjesec(double first, double second) {
    uk = first - second;
  }

  void dodajRashod(String key, double value, String idKat) {
    final kategorija =
        kategorijaLista.singleWhere((element) => element.id == idKat);
    kategorija.mapaRashoda[key] = value;
    notifyListeners();
    DatabaseHelper.updateRashodKategorije('kategorije', idKat, key, value);
  }

  void dodajKategoriju(String nazivNovi, int redniBroj) {
    var novaKategorija = KategorijaModel(
      naziv: nazivNovi,
      id: DateTime.now().toString(),
      mapaRashoda: {
        'Januar': 0.0,
        'Februar': 0.0,
        'Mart': 0.0,
        'April': 0.0,
        'Maj': 0.0,
        'Juni': 0.0,
        'Juli': 0.0,
        'August': 0.0,
        'Septembar': 0.0,
        'Oktobar': 0.0,
        'Novembar': 0.0,
        'Decembar': 0.0,
      },
      isExpanded: false,
      slikaUrl: 'assets/images/nema-slike.jpg',
      redniBroj: redniBroj,
      mjesecnoDodavanje: 1,
      jeLiMjesecnoDodano: 'ne',
    );

    kategorijaLista.add(novaKategorija);
    notifyListeners();
    DatabaseHelper.insertKategorije('kategorije', {
      'id': novaKategorija.id,
      'naziv': novaKategorija.naziv,
      'slikaUrl': novaKategorija.slikaUrl,
      'redniBroj': redniBroj,
      'mjesecnoDodavanje': 1,
      'jeLiMjesecnoDodano': 'ne',
      'Januar': 0.0,
      'Februar': 0.0,
      'Mart': 0.0,
      'April': 0.0,
      'Maj': 0.0,
      'Juni': 0.0,
      'Juli': 0.0,
      'August': 0.0,
      'Septembar': 0.0,
      'Oktobar': 0.0,
      'Novembar': 0.0,
      'Decembar': 0.0,
    });
  }

  Future<void> fetchAndSetKategorije() async {
    final dataList = await DatabaseHelper.fetchTabele('kategorije');

    List<KategorijaModel> s = [];
    dataList.forEach((e) {
      s.add(KategorijaModel(
          naziv: e['naziv'],
          id: e['id'],
          slikaUrl: e['slikaUrl'],
          slikaEncoded: e['slikaUrl'] == 'assets/images/nema-slike.jpg'
              ? null
              : base64Decode(e['slikaUrl']),
          redniBroj: e['redniBroj'],
          mjesecnoDodavanje: e['mjesecnoDodavanje'],
          jeLiMjesecnoDodano: e['jeLiMjesecnoDodano'],
          mapaRashoda: {
            'Januar': e['Januar'],
            'Februar': e['Februar'],
            'Mart': e['Mart'],
            'April': e['April'],
            'Maj': e['Maj'],
            'Juni': e['Juni'],
            'Juli': e['Juli'],
            'August': e['August'],
            'Septembar': e['Septembar'],
            'Oktobar': e['Oktobar'],
            'Novembar': e['Novembar'],
            'Decembar': e['Decembar']
          }));
    });

    kategorijaLista = s;
    kategorijaLista.sort((a, b) {
      return a.redniBroj.compareTo(b.redniBroj);
    });

    notifyListeners();
  }

  void izbrisiKategoriju(String id, List<PotrosnjaModel> listaPotrosnji,
      List<PotKategorija> listaPotkategorija) {
    kategorijaLista.removeWhere((item) {
      return item.id == id;
    });

    notifyListeners();
    DatabaseHelper.izbrisiKategoriju('kategorije', id);
    DatabaseHelper.izbrisiPotrosnjeuKategoriji('potrosnje', listaPotrosnji);
    DatabaseHelper.izbrisiPotkategorijeuKategoriji(
        'potkategorije', listaPotkategorija);
    rpDB.DatabaseHelper.izbrisiRashodKategorije('rashodKategorija', id);
  }

  void updateSlikuKategorije(String slikaPath, String id) {
    KategorijaModel kategorija =
        kategorijaLista.singleWhere((element) => element.id == id);
    kategorija.slikaUrl = slikaPath;
    kategorija.slikaEncoded = base64Decode(slikaPath);
    notifyListeners();
    DatabaseHelper.updateKategoriju('kategorije', 'slikaUrl', slikaPath, id);
  }

  void updateRedniBrojKategorije(int redniBroj, String id) {
    kategorijaLista.singleWhere((element) => element.id == id).redniBroj =
        redniBroj;
    DatabaseHelper.updateRedniBrojKategorije('kategorije', redniBroj, id);
    notifyListeners();
  }

  void updateMjesecnoDodavanjeKategorije(String id, int mjesecnoDodavanje) {
    kategorijaLista
        .singleWhere((element) => element.id == id)
        .mjesecnoDodavanje = mjesecnoDodavanje;
    DatabaseHelper.updateMjesecnoDodavanje('kategorije', mjesecnoDodavanje, id);
    notifyListeners();
  }

  KategorijaModel dobijKategorijuPoId(String id) {
    return kategorijaLista.singleWhere((element) => element.id == id);
  }

  void updateNazivKategorije(String naziv, String id) {
    KategorijaModel kategorija =
        kategorijaLista.singleWhere((element) => element.id == id);
    kategorija.naziv = naziv;
    notifyListeners();
    DatabaseHelper.updateKategoriju('kategorije', 'naziv', naziv, id);
  }
}

// BOJA MODEL

class Boja {
  final String id;
  final Color color;

  const Boja({@required this.id, this.color = Colors.orange});
}

//POTKATEGORIJA MODEL

class PotKategorija {
  String naziv;
  String idKat;
  String idPot;
  int icon;
  Color bojaIkone;
  int mjesecnoDodavanje;
  String jeLiMjesecnoDodano;

  PotKategorija(
      {this.naziv,
      this.idKat,
      this.idPot,
      this.icon,
      this.bojaIkone,
      this.mjesecnoDodavanje,
      this.jeLiMjesecnoDodano});
}

class PotKategorijaLista with ChangeNotifier {
  List<PotKategorija> potKategorijaLista = [];

  var ukupnoPotrosnjiUPotkategoriji = 0;

  int potKategorijePoKategoriji(String id) {
    List<PotKategorija> lista = [];
    lista = potKategorijaLista.where((element) => element.idKat == id).toList();
    return lista.length;
  }

   String dobijNazivPotKategorije(String idPot) {
    PotKategorija potKat = potKategorijaLista.singleWhere((element) {
      return element.idPot == idPot;
    }, orElse: () {
      return null;
    });
    if (potKat == null) {
      return 'Potkategorija izbrisana';
    }
    return potKat.naziv;
  }

  List<PotKategorija> potKategorijePoKategorijilista(String id) {
    List<PotKategorija> lista = [];
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

    var novaPotKategorija = PotKategorija(
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
      return PotKategorija(
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

  List<PotrosnjaModel> dostPotKat = [];

  void dodajUPotKatList(PotrosnjaModel item) {
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

  void izbrisiPotkategoriju(String id, List<PotrosnjaModel> listaPotrosnji) {
    potKategorijaLista.removeWhere((test) {
      return test.idPot == id;
    });
    notifyListeners();

    DatabaseHelper.izbrisiPotkategoriju('potkategorije', id);
    DatabaseHelper.izbrisiPotrosnjeuPotkategoriji('potrosnje', listaPotrosnji);
  }

  List<PotKategorija> get ukupnoPotkategorija {
    return potKategorijaLista;
  }

  List<PotKategorija> dobijdostupnePotkategorije(String idKat) {
    return potKategorijaLista.where((item) {
      return item.idKat == idKat;
    }).toList();
  }
}

class SveKategorije extends ChangeNotifier {
  //Postavke prikaz
  bool vertikalniPrikaz;
  bool brisanjeKategorija;

  //Postavke sigurnost
  bool zastitaLozinkom;

  Map<String, double> rashodSveKategorijeMapa = {
    'Januar': 0.0,
    'Februar': 0.0,
    'Mart': 0.0,
    'April': 0.0,
    'Maj': 0.0,
    'Juni': 0.0,
    'Juli': 0.0,
    'August': 0.0,
    'Septembar': 0.0,
    'Oktobar': 0.0,
    'Novembar': 0.0,
    'Decembar': 0.0,
  };

  void dodajRashod(String key, double value) {
    rashodSveKategorijeMapa[key] = value;
    notifyListeners();
    DatabaseHelper.updateRashodUkupnoGodina('rashodGodina', key, value);
  }

  Future<void> fetchAndSetRashod() async {
    final dataList = await DatabaseHelper.fetchTabele('rashodGodina');

    rashodSveKategorijeMapa['Januar'] = dataList[0]['Januar'];
    rashodSveKategorijeMapa['Februar'] = dataList[0]['Februar'];
    rashodSveKategorijeMapa['Mart'] = dataList[0]['Mart'];
    rashodSveKategorijeMapa['April'] = dataList[0]['April'];
    rashodSveKategorijeMapa['Maj'] = dataList[0]['Maj'];
    rashodSveKategorijeMapa['Juni'] = dataList[0]['Juni'];
    rashodSveKategorijeMapa['Juli'] = dataList[0]['Juli'];
    rashodSveKategorijeMapa['August'] = dataList[0]['August'];
    rashodSveKategorijeMapa['Septembar'] = dataList[0]['Septembar'];
    rashodSveKategorijeMapa['Oktobar'] = dataList[0]['Oktobar'];
    rashodSveKategorijeMapa['Novembar'] = dataList[0]['Novembar'];
    rashodSveKategorijeMapa['Decembar'] = dataList[0]['Decembar'];

    notifyListeners();
  }

  void vertikalniPrikazToggle() {
    vertikalniPrikaz = !vertikalniPrikaz;
    if (vertikalniPrikaz) {
      DatabaseHelper.updatePostavke('postavke', 'prikazPotrosnji', 1);
    } else {
      DatabaseHelper.updatePostavke('postavke', 'prikazPotrosnji', 0);
    }
    notifyListeners();
  }

  void brisanjeKategorijaToggle() {
    brisanjeKategorija = !brisanjeKategorija;
    if (brisanjeKategorija) {
      DatabaseHelper.updatePostavke('postavke', 'brisanjeKategorija', 1);
    } else {
      DatabaseHelper.updatePostavke('postavke', 'brisanjeKategorija', 0);
    }

    notifyListeners();
  }

  void zastitaLozinkomToggle() {
    zastitaLozinkom = !zastitaLozinkom;
    if (zastitaLozinkom) {
      DatabaseHelper.updatePostavke('postavke', 'zastitaLozinkom', 1);
    } else {
      DatabaseHelper.updatePostavke('postavke', 'zastitaLozinkom', 0);
    }

    notifyListeners();
  }

  Future<void> fetchAndSetPostavke() async {
    final dataList = await DatabaseHelper.fetchTabele('postavke');

    if (dataList[0]['prikazPotrosnji'] == 0) {
      vertikalniPrikaz = false;
      notifyListeners();
    } else {
      vertikalniPrikaz = true;
      notifyListeners();
    }

    if (dataList[0]['brisanjeKategorija'] == 0) {
      brisanjeKategorija = false;
      notifyListeners();
    } else {
      brisanjeKategorija = true;
      notifyListeners();
    }

    if (dataList[0]['zastitaLozinkom'] == 0) {
      zastitaLozinkom = false;
      notifyListeners();
    } else {
      zastitaLozinkom = true;
      notifyListeners();
    }
  }
}
