import 'package:expen/providers/bottomNavigationNotifier.dart';
import 'package:flutter/material.dart';
import '../../subcategoryScreen/pages/subcategoryScreen.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import '../../categoryScreen/pages/categoryStatisticsScreen.dart';
import 'package:provider/provider.dart';

class SubcategoryBottomNavigationScreen extends StatefulWidget {
  final SubcategoryModel potkategorija;
  final CategoryModel kategorija;

  SubcategoryBottomNavigationScreen(this.potkategorija, this.kategorija);

  @override
  _SubcategoryBottomNavigationScreenState createState() =>
      _SubcategoryBottomNavigationScreenState();
}

class _SubcategoryBottomNavigationScreenState
    extends State<SubcategoryBottomNavigationScreen> {
  List<ExpenseModel> get dostupnePotrosnje {
    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(context);
    return expenseNotifier.listaSvihPotrosnji.where((item) {
      return item.idKategorije == widget.kategorija.id &&
          item.idPotKategorije == widget.potkategorija.idPot;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(context);
    final bottomNavigationNotifier =
        Provider.of<BottomNavigationNotifier>(context);
    expenseNotifier.dobijDostupnePotrosnje(dostupnePotrosnje);

    final List<Object> _pages = [
      SubcategoryScreen(widget.potkategorija, widget.kategorija),
      CategoryStatisticsScreen(
        kategorijaLista: widget.kategorija,
        dostupnePotrosnje: dostupnePotrosnje,
        title: widget.potkategorija.naziv,
        uPotkategoriji: true,
        potKategorija: widget.potkategorija,
      ),
    ];

    return Scaffold(
      body: _pages[bottomNavigationNotifier.subcategoryNavigationIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: bottomNavigationNotifier.onSubcategoryNavigationChange,
          backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.black,
          currentIndex: bottomNavigationNotifier.subcategoryNavigationIndex,
          items: bottomNavigationNotifier.subcategoryNavigationItems(context)),
    );
  }
}
