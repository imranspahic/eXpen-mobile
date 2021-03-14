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
  final jeLiDrawer;

  final CategoryModel kategorija;
  CategoryBottomNavigationScreen(this.kategorija, this.jeLiDrawer);

  @override
  _CategoryBottomNavigationScreenState createState() =>
      _CategoryBottomNavigationScreenState();
}

class _CategoryBottomNavigationScreenState
    extends State<CategoryBottomNavigationScreen> {
  List<ExpenseModel> get dostupnePotrosnjeUCijelojKategoriji {
    final potrosnjaData = Provider.of<ExpenseNotifier>(context);
    return potrosnjaData.listaSvihPotrosnji.where((item) {
      return item.idKategorije == widget.kategorija.id;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final potrosnjaData = Provider.of<ExpenseNotifier>(context);
    final potKatData = Provider.of<SubcategoryNotifier>(context);
    final bottomNavigationNotifier =
        Provider.of<BottomNavigationNotifier>(context);
    final List<Object> _pages = [
      CategoryScreen(
        category: widget.kategorija,
        dostupnePotrosnje:
            potrosnjaData.dobijdostupnePotrosnje(widget.kategorija.id),
        dostupnePotkategorije:
            potKatData.dobijdostupnePotkategorije(widget.kategorija.id),
        jeLiDrawer: widget.jeLiDrawer,
      ),
      CategoryStatisticsScreen(
        kategorijaLista: widget.kategorija,
        dostupnePotrosnje: dostupnePotrosnjeUCijelojKategoriji,
        title: '',
        uPotkategoriji: false,
        dostupnePotkategorije:
            potKatData.dobijdostupnePotkategorije(widget.kategorija.id),
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
