import 'package:expen/providers/categoryNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewCategoryService {
  void addNewCategory(
      BuildContext context, TextEditingController fieldController) {
    final uneseniNaziv = fieldController.text;

    if (uneseniNaziv.isEmpty || uneseniNaziv.length > 25) {
      Navigator.of(context).pop('error');
      return;
    }

    final CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context, listen: false);
    int redniBroj;

    redniBroj = categoryNotifier.kategorijaLista.length + 1;
    categoryNotifier.dodajKategoriju(uneseniNaziv, redniBroj);
    Navigator.of(context).pop();
  }
}
