import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './kategorija_pojedinacna.dart';
import '../model/data_provider.dart';
import './grafovi_kategorija_ekran.dart';
import './rashod_kategorija_ekran.dart';

class TabKategorijaEkran extends StatefulWidget {
  static const routeName = 'tab-kategorija-ekran';
  final jeLiDrawer;

  final KategorijaModel kategorija;
  TabKategorijaEkran(this.kategorija, this.jeLiDrawer);

  @override
  _TabKategorijaEkranState createState() => _TabKategorijaEkranState();
}

class _TabKategorijaEkranState extends State<TabKategorijaEkran> {
  int _selectedPageIndex = 0;

  //izvan potkategorije GENERALNO
  // List<PotrosnjaModel> get dostupnePotrosnje {
    
  //   final potrosnjaData = Provider.of<PotrosnjaLista>(context);
  //   List<PotrosnjaModel> tempList;
  //   tempList = potrosnjaData.listaSvihPotrosnji.where((item) {
  //     return item.idKategorije == widget.kategorija.id &&
  //         item.idPotKategorije == 'nemaPotkategorija';
  //   }).toList();
  //   tempList.sort((a,b) {
  //     return -a.datum.compareTo(b.datum);
  //   });
  //   return tempList;
  // }

  List<PotrosnjaModel> get dostupnePotrosnjeUCijelojKategoriji {
    final potrosnjaData = Provider.of<PotrosnjaLista>(context);
    return potrosnjaData.listaSvihPotrosnji.where((item) {
      return item.idKategorije == widget.kategorija.id;
    }).toList();
  }

  //u potkategoriji
  // List<PotKategorija> get dostupnePotkategorije {
  //   final potKatData = Provider.of<PotKategorijaLista>(context);
  //   return potKatData.potKategorijaLista.where((item) {
  //     return item.idKat == widget.kategorija.id;
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
  final potrosnjaData = Provider.of<PotrosnjaLista>(context);
  final potKatData = Provider.of<PotKategorijaLista>(context);
    final List<Object> _pages = [
      KategorijaPojedinacna(
        kategorija: widget.kategorija,
        dostupnePotrosnje: potrosnjaData.dobijdostupnePotrosnje(widget.kategorija.id),
        dostupnePotkategorije: potKatData.dobijdostupnePotkategorije(widget.kategorija.id),
        jeLiDrawer: widget.jeLiDrawer,
      ),
      GrafoviKategorijaEkran(
        kategorijaLista: widget.kategorija,
        dostupnePotrosnje: dostupnePotrosnjeUCijelojKategoriji,
        title: '',
        uPotkategoriji: false,
        dostupnePotkategorije: potKatData.dobijdostupnePotkategorije(widget.kategorija.id),
      ),
      RashodKategorijaEkran(
        widget.kategorija,
        dostupnePotrosnjeUCijelojKategoriji,
      ),
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
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.attach_money),
            title: Text('Rashod'),
          ),
        ],
      ),
    );
  }
}
