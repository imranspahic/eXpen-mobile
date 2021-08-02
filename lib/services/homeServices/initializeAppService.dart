import 'dart:async';

import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/homeInitializeNotifier.dart';
import 'package:expen/providers/notificationNotifier.dart';
import 'package:expen/providers/settingsNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import 'package:expen/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class InitializeAppService {
  static Future<void> initialize(BuildContext context) async {
    print("calling home initialize()");
    final HomeInitializeNotifier homeInitializeNotifier =
        Provider.of<HomeInitializeNotifier>(context, listen: false);

    if (!homeInitializeNotifier.isInitializing) return;

    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(context, listen: false);
    final NotificationNotifier notificationNotifier =
        Provider.of<NotificationNotifier>(context, listen: false);
    final CategoryNotifier categoryNotifier =
        Provider.of<CategoryNotifier>(context, listen: false);
    final SettingsNotifier settingsNotifier =
        Provider.of<SettingsNotifier>(context, listen: false);
    final SubcategoryNotifier subcategoryNotifier =
        Provider.of<SubcategoryNotifier>(context, listen: false);

    expenseNotifier
        .provjeriMjesecnoDodavanjeKategorija()
        .then((listaObavijesti) {
      if (listaObavijesti.isNotEmpty) {
        listaObavijesti.forEach((obavijest) {
          notificationNotifier.dodajObavijest(
              obavijest['sadrzaj'],
              obavijest['datum'],
              obavijest['idKategorije'],
              obavijest['idPotKategorije'],
              obavijest['jeLiProcitano']);
        });
      }
    });

    Timer.periodic(Duration(hours: 24), (timer) {
      print("home initializing here");
      expenseNotifier
          .provjeriMjesecnoDodavanjeKategorija()
          .then((listaObavijesti) {
        if (listaObavijesti.isNotEmpty) {
          listaObavijesti.forEach((obavijest) {
            notificationNotifier.dodajObavijest(
                obavijest['sadrzaj'],
                obavijest['datum'],
                obavijest['idKategorije'],
                obavijest['idPotKategorije'],
                obavijest['jeLiProcitano']);
          });
        }
      });
    });

    await expenseNotifier.fetchAndSetPotrosnje();
    await categoryNotifier.fetchAndSetKategorije(context);
    await subcategoryNotifier.fetchAndSetPotkategorije();
    await notificationNotifier.fetchAndSetObavijesti();
    await settingsNotifier.fetchAndSetPostavke(context, true);

    await Future.delayed(Duration(seconds: 1));

    homeInitializeNotifier.setInitializing(false);
  }
}
