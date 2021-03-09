import 'package:flutter/material.dart';
import './potkategorija_ekran.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import './grafovi_kategorija_ekran.dart';
import 'package:provider/provider.dart';

class TabPotKategorijaEkran extends StatefulWidget {
  static const routeName = 'tab-kategorija-ekran';

  final SubcategoryModel potkategorija;
  final CategoryModel kategorija;

  TabPotKategorijaEkran(this.potkategorija, this.kategorija);

  @override
  _TabPotKategorijaEkranState createState() => _TabPotKategorijaEkranState();
}

class _TabPotKategorijaEkranState extends State<TabPotKategorijaEkran> {
  int _selectedPageIndex = 0;

  List<ExpenseModel> get dostupnePotrosnje {
    final potrosnjaData = Provider.of<ExpenseNotifier>(context);
    return potrosnjaData.listaSvihPotrosnji.where((item) {
      return item.idKategorije == widget.kategorija.id && item.idPotKategorije == widget.potkategorija.idPot;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final potrosnjaData = Provider.of<ExpenseNotifier>(context);
    potrosnjaData.dobijDostupnePotrosnje(dostupnePotrosnje);

    final List<Object> _pages = [
      PotKategorijaEkran(widget.potkategorija, widget.kategorija),
      GrafoviKategorijaEkran(kategorijaLista: widget.kategorija, dostupnePotrosnje: dostupnePotrosnje, title: widget.potkategorija.naziv, uPotkategoriji: true, potKategorija: widget.potkategorija,),
    ];

    void _selectPage(int index) {
      setState(() {
        _selectedPageIndex = index;
      });
    }

    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
            title: Text('Lista potrošnji'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.info_outline),
            title: Text('Detalji'),
          ),
        ],
      ),
    );
  }
}
