import 'dart:async';
import 'package:expen/providers/profileNotifier.dart';
import 'package:expen/services/dialogServices/showDialogService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/view/homeScreen/widgets/homeScreenAppBar.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/providers/settingsNotifier.dart';
import '../../../providers/notificationNotifier.dart';
import '../../../widgets/potrosnja_kategorija.dart';
import '../../drawerScreen/pages/main_drawer.dart';

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

    Provider.of<ExpenseNotifier>(context, listen: false)
        .provjeriMjesecnoDodavanjeKategorija()
        .then((listaObavijesti) {
      if (listaObavijesti.isNotEmpty) {
        listaObavijesti.forEach((obavijest) {
          Provider.of<NotificationNotifier>(context, listen: false)
              .dodajObavijest(
                  obavijest['sadrzaj'],
                  obavijest['datum'],
                  obavijest['idKategorije'],
                  obavijest['idPotKategorije'],
                  obavijest['jeLiProcitano']);
        });
      }
    });
    Timer.periodic(Duration(hours: 24), (timer) {
      Provider.of<ExpenseNotifier>(context, listen: false)
          .provjeriMjesecnoDodavanjeKategorija()
          .then((listaObavijesti) {
        if (listaObavijesti.isNotEmpty) {
          listaObavijesti.forEach((obavijest) {
            Provider.of<NotificationNotifier>(context, listen: false)
                .dodajObavijest(
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
    kategorijeFuture = Provider.of<CategoryNotifier>(context, listen: false)
        .fetchAndSetKategorije(context);
    Provider.of<NotificationNotifier>(context, listen: false)
        .fetchAndSetObavijesti();
    postavkeFuture = Provider.of<SettingsNotifier>(context, listen: false)
        .fetchAndSetPostavke(context, false);
  }

  @override
  Widget build(BuildContext context) {
    final CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context);
    final obavijestiData = Provider.of<NotificationNotifier>(context);
    final profileNotifier = Provider.of<ProfileNotifier>(context);

    print("ACCES TOKEN = ${profileNotifier.userData["accessToken"]}");

    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(categoryNotifier.kategorijaLista,
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
                  children: categoryNotifier.kategorijaLista
                      .map((item) => Container(
                          height: 320,
                          key: Key(item.id),
                          child: PotrosnjaKategorija(item)))
                      .toList(),
                  onReorder: (start, current) {
                    List<CategoryModel> _list = categoryNotifier.kategorijaLista;
                    if (current >= _list.length) {
                      current = _list.length - 1;
                    }
                    if (start < current) {
                      //unijeti current kao redni broj u bazu
                      categoryNotifier.updateRedniBrojKategorije(
                          start + 1, categoryNotifier.kategorijaLista[current].id);
                      categoryNotifier.updateRedniBrojKategorije(
                          current + 1, categoryNotifier.kategorijaLista[start].id);
                      print('start index: $start');
                      print('current index $current');
                      int end = current;
                      CategoryModel startItem = _list[start];
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
                      categoryNotifier.updateRedniBrojKategorije(
                          start + 1, categoryNotifier.kategorijaLista[current].id);
                      categoryNotifier.updateRedniBrojKategorije(
                          current + 1, categoryNotifier.kategorijaLista[start].id);
                      print('start index: $start');
                      print('current index: $current');
                      CategoryModel startItem = _list[start];
                      for (int i = start; i > current; i--) {
                        _list[i] = _list[i - 1];
                      }
                      _list[current] = startItem;
                    }

                    setState(() {});
                  },

                  //      final KategorijaModel kategorija = categoryNotifier.kategorijaLista.elementAt(staraPozicija);
                  //  categoryNotifier.kategorijaLista.remove(kategorija);
                  //  categoryNotifier.kategorijaLista.insert(novaPozicija, kategorija);
                );
                //     ListView.builder(
                // itemCount: categoryNotifier.kategorijaLista.length,
                // itemBuilder: (ctx, index) {
                //   return PotrosnjaKategorija(categoryNotifier.kategorijaLista[index]); //izgled kategorije
                // });
              })),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            ShowDialogService.addCategoryDialog(context, _scaffoldKey),
      ),
    );
  }
}
