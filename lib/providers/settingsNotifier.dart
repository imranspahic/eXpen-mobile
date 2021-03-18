import 'package:expen/viewModel/userViewModel/getUserDataSharedPrefsVM.dart';
import 'package:flutter/material.dart';
import 'package:expen/database/glavni_podaci_database.dart';

class SettingsNotifier extends ChangeNotifier {
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
    DatabaseHelper.updateRowInTable('rashodGodina', key, value);
  }

  Future<void> fetchAndSetRashod() async {
    final dataList = await DatabaseHelper.fetchTable('rashodGodina');

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
      DatabaseHelper.updateRowInTable('postavke', 'prikazPotrosnji', 1);
    } else {
      DatabaseHelper.updateRowInTable('postavke', 'prikazPotrosnji', 0);
    }
    notifyListeners();
  }

  void brisanjeKategorijaToggle() {
    brisanjeKategorija = !brisanjeKategorija;
    if (brisanjeKategorija) {
      DatabaseHelper.updateRowInTable('postavke', 'brisanjeKategorija', 1);
    } else {
      DatabaseHelper.updateRowInTable('postavke', 'brisanjeKategorija', 0);
    }

    notifyListeners();
  }

  void zastitaLozinkomToggle() {
    zastitaLozinkom = !zastitaLozinkom;
    if (zastitaLozinkom) {
      DatabaseHelper.updateRowInTable('postavke', 'zastitaLozinkom', 1);
    } else {
      DatabaseHelper.updateRowInTable('postavke', 'zastitaLozinkom', 0);
    }

    notifyListeners();
  }

  Future<void> fetchAndSetPostavke(BuildContext context, bool isStart) async {
    print("INITTTTT");
    if (isStart) {
      print("SDASFASFA");
      await getUserDataSharedPrefs(context);
    }
    final dataList = await DatabaseHelper.fetchTable('postavke');

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
