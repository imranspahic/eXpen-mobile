import 'package:expen/models/Category.dart';
import 'package:expen/services/dialogServices/showDialogService.dart';
import 'package:expen/services/navigatorServices/navigateToPageService.dart';
import 'package:expen/view/dodaj_rashod_ekran.dart';
import 'package:expen/view/dodaj_vise_potrosnji.dart';
import 'package:expen/view/planirane_potrosnje_ekran.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

Widget buildSpeedDial(BuildContext context, Category category) {
  return SpeedDial(
    curve: Curves.bounceIn,
    animatedIcon: AnimatedIcons.menu_close,
    animatedIconTheme: IconThemeData(size: 24.0, color: Colors.white),
    marginBottom: 25,
    marginRight: 22,
    overlayColor: Colors.white,
    backgroundColor: Theme.of(context).accentColor,
    foregroundColor: Colors.black,
    elevation: 8.0,
    overlayOpacity: 0.5,
    heroTag: 'speed-dial-hero',
    shape: CircleBorder(),
    children: [
      SpeedDialChild(
        backgroundColor: Colors.red,
        label: 'Dodaj potrošnju',
        labelStyle: TextStyle(fontSize: 18),
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onTap: () => ShowDialogService.expenseAddDialog(context, category),
      ),
      SpeedDialChild(
        backgroundColor: Colors.blue,
        label: 'Dodaj više potrošnji',
        labelStyle: TextStyle(fontSize: 18),
        child: Icon(Icons.playlist_add, size: 30),
        onTap: () => NavigateToPageService.navigate(
            context,
            DodajVisePotrosnji(
              kategorija: category,
              uPotkategoriji: false,
            )),
      ),
      SpeedDialChild(
        backgroundColor: Colors.green,
        label: 'Dodaj potkategoriju',
        labelStyle: TextStyle(fontSize: 18),
        child: Icon(
          Icons.add_box,
          size: 27,
        ),
        onTap: () => ShowDialogService.subcategoryAddDialog(context, category),
      ),
      SpeedDialChild(
        backgroundColor: Colors.black,
        label: 'Dodaj rashod',
        labelStyle: TextStyle(fontSize: 18),
        child: Icon(Icons.playlist_add, size: 30),
        onTap: () => NavigateToPageService.navigate(
            context,
            DodajRashodEkran(
              kategorija: category,
              isKategorija: true,
            )),
      ),
      SpeedDialChild(
          backgroundColor: Colors.yellow[600],
          label: 'Planirane potrošnje',
          labelStyle: TextStyle(fontSize: 18),
          child: Icon(Icons.work, size: 28),
          onTap: () => NavigateToPageService.navigate(
              context,
              PlaniranePotrosnjeEkran(
                kategorija: category,
              ))),
    ],
  );
}
