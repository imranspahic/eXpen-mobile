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

    final katData = Provider.of<CategoryNotifier>(context, listen: false);
    int redniBroj;

    redniBroj = katData.kategorijaLista.length + 1;
    katData.dodajKategoriju(uneseniNaziv, redniBroj);
    Navigator.of(context).pop();
  }
}
