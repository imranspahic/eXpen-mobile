import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semir_potrosnja/view/homeScreen/widgets/homeScreenAppBar.dart';
import 'package:semir_potrosnja/viewModel/categoryViewModel/showAddCategoryDialogViewModel.dart';
import '../../../model/data_provider.dart';
import '../../../model/obavijesti_provider.dart';
import '../../../widgets/potrosnja_kategorija.dart';
import '../../../widgets/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future kategorijeFuture;
  Future postavkeFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Provider.of<PotrosnjaLista>(context, listen: false)
        .provjeriMjesecnoDodavanjeKategorija()
        .then((listaObavijesti) {
      if (listaObavijesti.isNotEmpty) {
        listaObavijesti.forEach((obavijest) {
          Provider.of<ObavijestiLista>(context, listen: false).dodajObavijest(
              obavijest['sadrzaj'],
              obavijest['datum'],
              obavijest['idKategorije'],
              obavijest['idPotKategorije'],
              obavijest['jeLiProcitano']);
        });
      }
    });
    Timer.periodic(Duration(hours: 24), (timer) {
      Provider.of<PotrosnjaLista>(context, listen: false)
          .provjeriMjesecnoDodavanjeKategorija()
          .then((listaObavijesti) {
        if (listaObavijesti.isNotEmpty) {
          listaObavijesti.forEach((obavijest) {
            Provider.of<ObavijestiLista>(context, listen: false).dodajObavijest(
                obavijest['sadrzaj'],
                obavijest['datum'],
                obavijest['idKategorije'],
                obavijest['idPotKategorije'],
                obavijest['jeLiProcitano']);
          });
        }
      });
    });
    // assign this variable your Future
    kategorijeFuture = Provider.of<KategorijaLista>(context, listen: false)
        .fetchAndSetKategorije();
    Provider.of<ObavijestiLista>(context, listen: false)
        .fetchAndSetObavijesti();
    postavkeFuture = Provider.of<SveKategorije>(context, listen: false)
        .fetchAndSetPostavke();
  }

  @override
  Widget build(BuildContext context) {
    final katData = Provider.of<KategorijaLista>(context);
    final obavijestiData = Provider.of<ObavijestiLista>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(katData.kategorijaLista,
          obavijestiData.listaNeprocitanihObavijesti()),
      appBar: homeScreenAppBar(
        context,
        _scaffoldKey,
      ),
      body: FutureBuilder(
          future: kategorijeFuture,
          builder: (ctx, snapshot) => FutureBuilder(
              future: postavkeFuture,
              builder: (ctx, snapshot) {
                return ReorderableListView(
                  children: katData.kategorijaLista
                      .map((item) => Container(
                          height: 320,
                          key: Key(item.id),
                          child: PotrosnjaKategorija(item)))
                      .toList(),
                  onReorder: (start, current) {
                    List<KategorijaModel> _list = katData.kategorijaLista;
                    if (current >= _list.length) {
                      current = _list.length - 1;
                    }
                    if (start < current) {
                      //unijeti current kao redni broj u bazu
                      katData.updateRedniBrojKategorije(
                          start + 1, katData.kategorijaLista[current].id);
                      katData.updateRedniBrojKategorije(
                          current + 1, katData.kategorijaLista[start].id);
                      print('start index: $start');
                      print('current index $current');
                      int end = current;
                      KategorijaModel startItem = _list[start];
                      int i = 0;
                      int local = start;
                      do {
                        _list[local] = _list[++local];
                        i++;
                      } while (i < end - start);
                      _list[end] = startItem;
                    }
                    // dragging from bottom to top
                    //unijeti current +1 kao redni broj u bazu
                    else if (start > current) {
                      katData.updateRedniBrojKategorije(
                          start + 1, katData.kategorijaLista[current].id);
                      katData.updateRedniBrojKategorije(
                          current + 1, katData.kategorijaLista[start].id);
                      print('start index: $start');
                      print('current index: $current');
                      KategorijaModel startItem = _list[start];
                      for (int i = start; i > current; i--) {
                        _list[i] = _list[i - 1];
                      }
                      _list[current] = startItem;
                    }

                    setState(() {});
                  },

                  //      final KategorijaModel kategorija = katData.kategorijaLista.elementAt(staraPozicija);
                  //  katData.kategorijaLista.remove(kategorija);
                  //  katData.kategorijaLista.insert(novaPozicija, kategorija);
                );
                //     ListView.builder(
                // itemCount: katData.kategorijaLista.length,
                // itemBuilder: (ctx, index) {
                //   return PotrosnjaKategorija(katData.kategorijaLista[index]); //izgled kategorije
                // });
              })),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showAddCategoryDialog(context, _scaffoldKey),
      ),
    );
  }
}
