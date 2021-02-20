import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:semir_potrosnja/model/rashod_kategorija_provider.dart';
import 'dart:math';

import '../ekrani/dodaj_rashod_ekran.dart';
import '../widgets/badge.dart';
import './edit_potkategorija_ekran.dart';
import './tab_potkategorija_ekran.dart';
import '../widgets/dodaj_novu_potkategoriju.dart';
import '../model/data_provider.dart';
import '../widgets/dodaj_novu_potrosnju.dart';
import '../widgets/izbrisi_dialog.dart';
import './dodaj_vise_potrosnji.dart';
import '../ekrani/planirane_potrosnje_ekran.dart';

class KategorijaPojedinacna extends StatefulWidget {
  static const routeName = 'kategorija-pojedinacna';
  final KategorijaModel kategorija;
  List<PotrosnjaModel> dostupnePotrosnje;
  final List<PotKategorija> dostupnePotkategorije;
  final bool jeLiDrawer;

  KategorijaPojedinacna(
      {this.kategorija,
      this.dostupnePotrosnje,
      this.dostupnePotkategorije,
      this.jeLiDrawer});

  @override
  _KategorijaPojedinacnaState createState() => _KategorijaPojedinacnaState();
}

class _KategorijaPojedinacnaState extends State<KategorijaPojedinacna> {
  Future potrosnjeFuture;
  Future potkategorijeFuture;

  bool listPregled = true;

  bool listPotKategorija = false;

  @override
  void initState() {
    super.initState();
    potrosnjeFuture = Provider.of<PotrosnjaLista>(context, listen: false)
        .fetchAndSetPotrosnje();
    potkategorijeFuture =
        Provider.of<PotKategorijaLista>(context, listen: false)
            .fetchAndSetPotkategorije();
    Provider.of<RashodKategorijaLista>(context, listen: false)
        .fetchAndSetRashodKategorija();
  }

  void pocniDodavatPotrosnje(ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (ctx) {
          return DodajNovuPotrosnju(
            kategorija: widget.kategorija,
            uPotkategoriji: false,
            jeLiPlaniranaPotrosnja: false,
          );
        }).then((t) {
      if (t[0] != null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Potrošnja dodana'),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  void otvoriDodavanjeVisePotrosnji(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return DodajVisePotrosnji(
        kategorija: widget.kategorija,
        uPotkategoriji: false,
      );
    }));
  }

  void pocniDodavatPotKategoriju(ctx) {
    showDialog(
        context: ctx,
        builder: (ctx) => SimpleDialog(children: <Widget>[
              Container(
                  height: 230,
                  width: 400,
                  child: DodajNovuPotKategoriju(widget.kategorija)),
            ])).then((value) {
      if (value != null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Potkategorija dodana'),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  void dodajRashod(ctx) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return DodajRashodEkran(
        kategorija: widget.kategorija,
        isKategorija: true,
      );
    }));
  }

  void planiranePotrosnje(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return PlaniranePotrosnjeEkran(
        kategorija: widget.kategorija,
      );
    }));
  }

  void otvoriPotKategoriju(BuildContext context, PotKategorija potkategorija) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return TabPotKategorijaEkran(potkategorija, widget.kategorija);
    }));
  }

  @override
  Widget build(BuildContext context) {
    final potrosnjaData = Provider.of<PotrosnjaLista>(context);
    final potKategorijaData =
        Provider.of<PotKategorijaLista>(context, listen: false);
    final postavkeData = Provider.of<SveKategorije>(context);

    return Scaffold(
      floatingActionButton: SpeedDial(
        curve: Curves.bounceIn,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 24.0, color: Colors.white),
        marginBottom: 25,
        marginRight: 22,
        overlayColor: Colors.white,
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.black,
        elevation: 8.0,
        overlayOpacity: 0.5,
        heroTag: 'speed-dial-hero',
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            backgroundColor: Colors.red,
            label: 'Dodaj potrošnju',
            labelStyle: TextStyle(fontSize: 18),
            child: Icon(
              Icons.add,
              size: 30,
            ),
            onTap: () => pocniDodavatPotrosnje(context),
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue,
            label: 'Dodaj više potrošnji',
            labelStyle: TextStyle(fontSize: 18),
            child: Icon(Icons.playlist_add, size: 30),
            onTap: () => otvoriDodavanjeVisePotrosnji(context),
          ),
          SpeedDialChild(
              backgroundColor: Colors.green,
              label: 'Dodaj potkategoriju',
              labelStyle: TextStyle(fontSize: 18),
              child: Icon(
                Icons.add_box,
                size: 27,
              ),
              onTap: () {
                pocniDodavatPotKategoriju(context);
              }),
          SpeedDialChild(
            backgroundColor: Colors.black,
            label: 'Dodaj rashod',
            labelStyle: TextStyle(fontSize: 18),
            child: Icon(Icons.playlist_add, size: 30),
            onTap: () => dodajRashod(context),
          ),
          SpeedDialChild(
              backgroundColor: Colors.yellow[600],
              label: 'Planirane potrošnje',
              labelStyle: TextStyle(fontSize: 18),
              child: Icon(Icons.work, size: 28),
              onTap: () => planiranePotrosnje(context)),
        ],
      ),
      appBar: AppBar(
        title: Text(widget.kategorija.naziv),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 5, bottom: 5),
              child: widget.jeLiDrawer
                  ? CircleAvatar(
                      radius: 25,
                      backgroundImage: widget.kategorija.slikaUrl ==
                              'assets/images/nema-slike.jpg'
                          ? AssetImage(widget.kategorija.slikaUrl)
                          : MemoryImage(
                              widget.kategorija.slikaEncoded,
                            ),
                    )
                  : Hero(
                      tag: widget.kategorija.id,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: widget.kategorija.slikaUrl ==
                                'assets/images/nema-slike.jpg'
                            ? AssetImage(widget.kategorija.slikaUrl)
                            : MemoryImage(
                                widget.kategorija.slikaEncoded,
                              ),
                      ),
                    ))
        ],
        // actions: <Widget>[
        //   postavkeData.vertikalniPrikaz
        //       ? IconButton(
        //           onPressed: () {
        //             postavkeData.vertikalniPrikazToggle();
        //           },
        //           icon: Icon(Icons.widgets),
        //         )
        //       : IconButton(
        //           onPressed: () {
        //            postavkeData.vertikalniPrikazToggle();
        //           },
        //           icon: Icon(Icons.list),
        //         )
        // ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(children: <Widget>[
              Container(
                height: min(widget.dostupnePotkategorije.length * 60.0,
                    double.infinity),
                child: FutureBuilder(
                  future: potkategorijeFuture,
                  builder: (ctx, snapshot) => ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.dostupnePotkategorije.length,
                    itemBuilder: (ctx, index) {
                      return Dismissible(
                        key:
                            ValueKey(widget.dostupnePotkategorije[index].idPot),
                        background: Container(
                          padding: EdgeInsets.only(right: 25),
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            size: 40,
                            color: Colors.white,
                          ),
                          alignment: Alignment.centerRight,
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          final potrosnjaData = Provider.of<PotrosnjaLista>(
                              context,
                              listen: false);
                          final List<PotrosnjaModel> lista =
                              potrosnjaData.potrosnjePoPotkaategorijilista(
                                  widget.dostupnePotkategorije[index].idPot);
                          //izbriši potkategorije
                          potKategorijaData.izbrisiPotkategoriju(
                              widget.dostupnePotkategorije[index].idPot, lista);
                          //izbriši potrošnje u potkategoriji
                          potrosnjaData.listaSvihPotrosnji.removeWhere((pot) {
                            return pot.idPotKategorije ==
                                widget.dostupnePotkategorije[index].idPot;
                          });
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Potkategorija izbrisana!',
                              style: TextStyle(fontSize: 16),
                            ),
                            duration: Duration(seconds: 2),
                          ));
                        },
                        child: ListTile(
                          leading: Badge(
                            child: Icon(
                              IconData(widget.dostupnePotkategorije[index].icon,
                                  fontFamily: 'MaterialIcons'),
                              size: 60,
                              color:
                                  widget.dostupnePotkategorije[index].bojaIkone,
                            ),
                            value: potrosnjaData.badge(
                                widget.dostupnePotkategorije[index].idPot),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 30,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (ctx) {
                                return EditPotkategorijaEkran(
                                    widget.dostupnePotkategorije[index]);
                              })).then((value) async {
                                await Provider.of<PotKategorijaLista>(context,
                                        listen: false)
                                    .fetchAndSetPotkategorije();
                                setState(() {});
                              });
                            },
                          ),
                          title:
                              Text(widget.dostupnePotkategorije[index].naziv),
                          onTap: () => otvoriPotKategoriju(
                              context, widget.dostupnePotkategorije[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
              postavkeData.vertikalniPrikaz
                  ? Container(
                      height: min(widget.dostupnePotrosnje.length * 80.0,
                          double.infinity),
                      child: FutureBuilder(
                        future: potrosnjeFuture,
                        builder: (ctx, p) => ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.dostupnePotrosnje.length,
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: <Widget>[
                                  Container(
                                    height: 80,
                                    child: Card(
                                      elevation: 3,
                                      child: ListTile(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return PrikaziPotrosnju(
                                                      potrosnja: widget
                                                              .dostupnePotrosnje[
                                                          index]);
                                                });
                                          },
                                          leading: Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              child: Text(
                                                '${widget.dostupnePotrosnje[index].trosak.toStringAsFixed(0)} KM',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              )),
                                          title: Text(
                                            widget
                                                .dostupnePotrosnje[index].naziv,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(DateFormat.yMMMd()
                                              .format(widget
                                                  .dostupnePotrosnje[index]
                                                  .datum)),
                                          trailing: IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) {
                                                      return IzbrisiDialog(
                                                        izbrisi: potrosnjaData
                                                            .izbrisiPotrosnju,
                                                        potrosnja: widget
                                                                .dostupnePotrosnje[
                                                            index],
                                                      );
                                                    });
                                                // potrosnjaData.izbrisiPotrosnju(
                                                //     widget
                                                //         .dostupnePotrosnje[index]
                                                //         .id);
                                              })),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ))
                  : Container(
                      height: widget.dostupnePotrosnje.length <= 4
                          ? 140.0
                          : widget.dostupnePotrosnje.length % 4 == 0
                              ? (widget.dostupnePotrosnje.length / 4) * 140.0
                              : (widget.dostupnePotrosnje.length / 4 + 1) *
                                  150.0,
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.dostupnePotrosnje.length,
                          padding: EdgeInsets.all(10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 4 / 5,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (ctx, index) {
                            return Card(
                              child: GridTile(
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: 10, right: 5, left: 5, bottom: 60),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    child: FittedBox(
                                      child: Text(
                                        '${widget.dostupnePotrosnje[index].trosak.toStringAsFixed(0)} KM',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                    )),
                                footer: Container(
                                  margin: EdgeInsets.only(bottom: 7),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.center,
                                          child: FittedBox(
                                            child: Text(
                                              widget.dostupnePotrosnje[index]
                                                  .naziv,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(fontSize: 19),
                                            ),
                                          )),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(DateFormat.yMMMd().format(
                                            widget.dostupnePotrosnje[index]
                                                .datum)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
            ]),
          ],
        ),
      ),
    );
  }
}

class PrikaziPotrosnju extends StatefulWidget {
  final PotrosnjaModel potrosnja;
  PrikaziPotrosnju({this.potrosnja});
  @override
  _PrikaziPotrosnjuState createState() => _PrikaziPotrosnjuState();
}

class _PrikaziPotrosnjuState extends State<PrikaziPotrosnju> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.43,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(children: <Widget>[
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.payment, color: Colors.orange[700], size: 60),
                    SizedBox(width: 10),
                    Text(
                      widget.potrosnja.naziv,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.orange[800]),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.orange, thickness: 2),
              SizedBox(height: 25),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.monetization_on, color: Colors.amber, size: 40),
                    SizedBox(width: 10),
                    Text(
                      '${widget.potrosnja.trosak} KM',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.date_range, color: Colors.purple, size: 40),
                    SizedBox(width: 10),
                    Text(
                      '${DateFormat('dd.MM.yyyy.').format(widget.potrosnja.datum)}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                  width: 100,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.orange,
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )),
            ]),
          ),
        )
      ],
    );
  }
}
