import 'package:expen/view/drawerScreen/widgets/drawerActionTile.dart';
import 'package:expen/view/drawerScreen/widgets/drawerCategoryList.dart';
import 'package:expen/view/drawerScreen/widgets/drawerExpenHeadline.dart';
import 'package:expen/view/drawerScreen/widgets/drawerNotificationList.dart';
import 'package:expen/view/drawerScreen/widgets/drawerSectionHeadline.dart';
import 'package:flutter/material.dart';
import 'package:expen/view/a%C5%BEuriranje_opcije.dart';
import 'package:expen/view/biljeske_ekran.dart';
import 'package:expen/view/detalji_kategorija_ekran.dart';
import 'package:expen/view/dodaj_rashod_ekran.dart';
import 'package:expen/view/obavijesti_ekran.dart';
import 'package:expen/view/settingsScreen/pages/settingsScreen.dart';
import 'package:expen/view/rashod_pregled_ekran.dart';

class ExpenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DrawerExpenHeadline(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DrawerSectionHeadline(
                  headlineText: "Kategorije",
                  headlineIcon: Icons.list,
                ),
                DrawerCategoryList(),
                DrawerSectionHeadline(
                  headlineText: "Obavijesti",
                  headlineIcon: Icons.notifications,
                ),
                DrawerNotificationList(),
                SizedBox(height: 23),
                DrawerActionTile(
                  actionName: "Prihod",
                  actionIcon: Icons.account_balance_wallet,
                  navigateTo: DodajRashodEkran(isKategorija: false),
                ),
                DrawerActionTile(
                  actionName: "Rashod",
                  actionIcon: Icons.flag,
                  navigateTo: RashodPregledEkran(),
                ),
                DrawerActionTile(
                  actionName: "Detalji",
                  actionIcon: Icons.more,
                  navigateTo: DetaljiKategorijaEkran(),
                ),
                DrawerActionTile(
                  actionName: "Bilješke",
                  actionIcon: Icons.library_books,
                  navigateTo: BiljeskeEkran(),
                ),
                DrawerActionTile(
                  actionName: "Obavijesti",
                  actionIcon: Icons.notifications,
                  navigateTo: ObavijestiEkran(),
                ),
                DrawerActionTile(
                  actionName: "Postavke",
                  actionIcon: Icons.settings,
                  navigateTo: SettingsScreen(),
                ),
                DrawerActionTile(
                  actionName: "Ažuriranje",
                  actionIcon: Icons.gavel,
                  navigateTo: AzuriranjeOpcije(),
                ),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
