import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/models/Expense.dart';

class DeleteSubcategoryService {
  static delete(BuildContext context, String subcategoryID) async {
    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(context, listen: false);
    final SubcategoryNotifier subcategoryNotifier =
        Provider.of<SubcategoryNotifier>(context, listen: false);
    final List<Expense> lista =
        expenseNotifier.potrosnjePoPotkaategorijilista(subcategoryID);
    //izbriši potkategorije
    subcategoryNotifier.izbrisiPotkategoriju(subcategoryID, lista);
    //izbriši potrošnje u potkategoriji
    expenseNotifier.listaSvihPotrosnji.removeWhere((pot) {
      return pot.idPotKategorije == subcategoryID;
    });
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        'Potkategorija izbrisana!',
        style: TextStyle(fontSize: 16),
      ),
      duration: Duration(seconds: 2),
    ));
  }
}
