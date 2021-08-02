import 'package:expen/models/Category.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:flutter/material.dart';
import 'package:expen/providers/notificationNotifier.dart';
import 'package:expen/view/a%C5%BEuriranje_opcije.dart';
import 'package:expen/view/biljeske_ekran.dart';
import 'package:expen/view/detalji_kategorija_ekran.dart';
import 'package:expen/view/dodaj_rashod_ekran.dart';
import 'package:expen/view/obavijesti_ekran.dart';
import 'package:expen/view/settingsScreen/pages/settingsScreen.dart';
import 'package:expen/view/rashod_pregled_ekran.dart';
import 'package:expen/view/bottomNavigationScreen/pages/categoryBottomNavigationScreen.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  void otvoriPlata(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return DodajRashodEkran(
        isKategorija: false,
      );
    }));
  }

  void otvoriPregledRashod(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return RashodPregledEkran();
    }));
  }

  void otvoriDetaljeKategorija(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return DetaljiKategorijaEkran();
    }));
  }

  void otvoriBiljeske(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return BiljeskeEkran();
    }));
  }

  void otvoriObavijesti(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return ObavijestiEkran();
    }));
  }

  void otvoriPostavke(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return SettingsScreen();
    }));
  }

  void otvoriAzuriranje(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return AzuriranjeOpcije();
    }));
  }

  Widget buildDrawerContent(BuildContext context, Category kategorija) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return CategoryBottomNavigationScreen(kategorija, true);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.orange[200],
        ),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        height: 45,
        child: FittedBox(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.assignment_ind,
                    size: 30,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Text(
                    kategorija.naziv,
                    style: Theme.of(context).textTheme.subtitle1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildObavijest(BuildContext context, NotificationModel obavijest) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return ObavijestiEkran(
            otvorenaObavijest: obavijest,
          );
          //obavijest pass
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.cyan[100],
        ),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        height: 60,
        child: FittedBox(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.notifications_active,
                    size: 25,
                    color: Colors.red[700],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: AutoSizeText(
                    obavijest.sadrzaj,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700]),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NotificationNotifier notificationNotifier =
        Provider.of<NotificationNotifier>(context);
    final CategoryNotifier categoryNotifier =
        Provider.of<CategoryNotifier>(context, listen: false);
    final List<Category> categories = categoryNotifier.kategorijaLista;
    final List<NotificationModel> unreadNotificatioms =
        notificationNotifier.listaNeprocitanihObavijesti();
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 150,
                color: Theme.of(context).primaryColor,
                child: Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/logo_coin_removed.png',
                              width: 80,
                              height: 80,
                            ),
                            SizedBox(width: 5),
                            RichText(
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.headline2,
                                  children: [
                                    TextSpan(text: 'e'),
                                    TextSpan(
                                        text: 'X',
                                        style: TextStyle(
                                            color: Colors.yellow[500],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 50)),
                                    TextSpan(text: 'pen'),
                                  ]),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Divider(
                            thickness: 3,
                            color: Colors.brown,
                            height: 10,
                          ),
                        )
                      ],
                    ))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    height: 60,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    child: Container(
                        padding: EdgeInsets.all(6),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.list, size: 25),
                            SizedBox(width: 10),
                            Text(
                              'Kategorije',
                              style: TextStyle(
                                  fontSize: 25, fontFamily: 'Raleway'),
                            ),
                          ],
                        ))),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black26, width: 1)),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: min(
                          categories.length * 52.5 +
                              categories.length * 5 +
                              (5 - categories.length),
                          double.infinity),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          itemCount: categories.length,
                          itemBuilder: (ctx, index) {
                            return buildDrawerContent(
                                context, categories[index]);
                          }),
                    ),
                    // if(potrosnjaLista.length >= 8)
                    // Positioned(bottom: 0, child: GestureDetector(
                    //   onTap: () {print('tapped');},
                    //                   child: Container(
                    //     width: 40,
                    //     height: 40,
                    //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.black45),
                    //     child: Icon(Icons.arrow_downward, color: Colors.white, size: 35,),
                    //   ),
                    // ), left: 130,),
                  ],
                ),
                Container(
                    height: 60,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                        padding: EdgeInsets.all(6),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.notifications, size: 25),
                            SizedBox(width: 10),
                            Text(
                              'Obavijesti',
                              style: TextStyle(
                                  fontSize: 25, fontFamily: 'Raleway'),
                            ),
                          ],
                        ))),

                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black26, width: 1)),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: min(
                          unreadNotificatioms.length * 70.5 +
                              unreadNotificatioms.length * 5 +
                              (5 - unreadNotificatioms.length),
                          220),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          itemCount: unreadNotificatioms.length,
                          itemBuilder: (ctx, index) {
                            return buildObavijest(
                                context, unreadNotificatioms[index]);
                          }),
                    ),
                  ],
                ),
                if (unreadNotificatioms.length > 3)
                  Center(
                    child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return ObavijestiEkran();
                          }));
                        },
                        child: Text(
                          'Prikaži još ${unreadNotificatioms.length - 3}...',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.red[600]),
                  ),
                InkWell(
                    onTap: () => otvoriPlata(context),
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 30, bottom: 7),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.account_balance_wallet,
                            color: Colors.green[700],
                          ),
                          SizedBox(width: 10),
                          Text('Prihod',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Raleway',
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                InkWell(
                    onTap: () => otvoriPregledRashod(context),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.flag,
                            color: Colors.deepOrange[400],
                          ),
                          SizedBox(width: 10),
                          Text('Rashod',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Raleway',
                                  color: Colors.deepOrange[400],
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                InkWell(
                  onTap: () => otvoriDetaljeKategorija(context),
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.more,
                            color: Colors.blue[700],
                          ),
                          SizedBox(width: 15),
                          Text('Detalji',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Raleway',
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                ),

                InkWell(
                  onTap: () => otvoriBiljeske(context),
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.library_books,
                            color: Colors.red[700],
                          ),
                          SizedBox(width: 15),
                          Text('Bilješke',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Raleway',
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                ),
                InkWell(
                  onTap: () => otvoriObavijesti(context),
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.notifications,
                            color: Colors.cyan[700],
                          ),
                          SizedBox(width: 15),
                          Text('Obavijesti',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Raleway',
                                  color: Colors.cyan[700],
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                ),

                InkWell(
                  onTap: () => otvoriPostavke(context),
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.settings,
                            color: Colors.purple,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Postavke',
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Raleway',
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),

                //RAZVOJNE OPCIJE
                //
                //
                ////
                /////
                //////
                ///////
                /////////
                //////////
                ///
                InkWell(
                  onTap: () => otvoriAzuriranje(context),
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.gavel,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Ažuriranje',
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Raleway',
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
                //
                //
                //
                //
                //
                //
                //
                //
                //
                //
                //
                //
              ],
            ),
          ],
        ),
      ),
    );
  }
}
