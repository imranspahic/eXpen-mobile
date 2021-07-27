import 'package:expen/providers/bottomNavigationNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../categoryScreen/pages/categoryScreen.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import '../../categoryScreen/pages/categoryStatisticsScreen.dart';
import 'package:expen/providers/categoryNotifier.dart';
import '../../categoryScreen/pages/categoryPlannedSpendingScreen.dart';

class CategoryBottomNavigationScreen extends StatefulWidget {
  final isDrawer;

  final CategoryModel kategorija;
  CategoryBottomNavigationScreen(this.kategorija, this.isDrawer);

  @override
  _CategoryBottomNavigationScreenState createState() =>
      _CategoryBottomNavigationScreenState();
}

class _CategoryBottomNavigationScreenState
    extends State<CategoryBottomNavigationScreen> {
  List<ExpenseModel> get dostupnePotrosnjeUCijelojKategoriji {
    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(context);
    return expenseNotifier.listaSvihPotrosnji.where((item) {
      return item.idKategorije == widget.kategorija.id;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(context);
    final SubcategoryNotifier subcategoryNotifier =
        Provider.of<SubcategoryNotifier>(context);
    final bottomNavigationNotifier =
        Provider.of<BottomNavigationNotifier>(context);
    final List<Object> _pages = [
      CategoryScreen(
        category: widget.kategorija,
        dostupnePotrosnje:
            expenseNotifier.dobijdostupnePotrosnje(widget.kategorija.id),
        dostupnePotkategorije: subcategoryNotifier
            .dobijdostupnePotkategorije(widget.kategorija.id),
        isDrawer: widget.isDrawer,
      ),
      CategoryStatisticsScreen(
        kategorijaLista: widget.kategorija,
        dostupnePotrosnje: dostupnePotrosnjeUCijelojKategoriji,
        title: '',
        uPotkategoriji: false,
        dostupnePotkategorije: subcategoryNotifier
            .dobijdostupnePotkategorije(widget.kategorija.id),
      ),
      CategoryPlannedSpendingScreen(
        widget.kategorija,
        dostupnePotrosnjeUCijelojKategoriji,
      ),
    ];

    return Scaffold(
      body: _pages[bottomNavigationNotifier.categoryNavigationIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: bottomNavigationNotifier.onCategoryNavigationChange,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        currentIndex: bottomNavigationNotifier.categoryNavigationIndex,
        items: bottomNavigationNotifier.categoryNavigationItems(context),
      ),
    );
  }
}
