import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/view/categoryScreen/widgets/expenseDialog.dart';
import 'package:expen/view/homeScreen/widgets/addNewCategoryDialog.dart';
import 'package:expen/widgets/dodaj_novu_potkategoriju.dart';
import 'package:expen/widgets/dodaj_novu_potrosnju.dart';
import 'package:flutter/material.dart';

class ShowDialogService {
  static addCategoryDialog(
      BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(children: <Widget>[
              Container(height: 230, width: 400, child: AddNewCategoryDialog()),
            ])).then((value) {
      if (value == 'error') {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              'Pogrešan unos, naziv ne smije biti prazan ili duži od 25 znakova'),
        ));
      }
    });
  }

  static expenseViewDialog(BuildContext context, ExpenseModel expense) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return ExpenseDialog(potrosnja: expense);
        });
  }

  static expenseAddDialog(BuildContext context, CategoryModel category) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return DodajNovuPotrosnju(
            kategorija: category,
            uPotkategoriji: false,
            jeLiPlaniranaPotrosnja: false,
          );
        }).then((t) {
      if (t[0] != null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Potrošnja dodana'),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  static subcategoryAddDialog(BuildContext context, CategoryModel category) {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(children: <Widget>[
              Container(
                  height: 230,
                  width: 400,
                  child: DodajNovuPotKategoriju(category)),
            ])).then((value) {
      if (value != null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Potkategorija dodana'),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }
}
