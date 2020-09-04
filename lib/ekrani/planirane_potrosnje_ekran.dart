import 'dart:math';
import 'package:flutter/material.dart';
import '../model/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/dodaj_novu_potrosnju.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PlaniranePotrosnjeEkran extends StatefulWidget {
  final KategorijaModel kategorija;
  final PotKategorija potKategorija;

  PlaniranePotrosnjeEkran({this.kategorija, this.potKategorija});

  @override
  _PlaniranePotrosnjeEkranState createState() =>
      _PlaniranePotrosnjeEkranState();
}

class _PlaniranePotrosnjeEkranState extends State<PlaniranePotrosnjeEkran> {
  Future planiranePotrosnjeFuture;
  int danDodavanja;

  void pocniDodavatPotrosnje(ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (ctx) {
          return DodajNovuPotrosnju(
            kategorija: widget.kategorija,
            uPotkategoriji: false,
            jeLiPlaniranaPotrosnja: true,
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
  void _izaberiDan() async {
    int s;

    s = await showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Column(
              children: <Widget>[
                Text(
                  'Odaberi dan u mjesecu',
                  style: TextStyle(fontSize: 25, fontFamily: 'Lato'),
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  thickness: 1,
                ),
              ],
            ),
            titlePadding: EdgeInsets.all(10),
            children: <Widget>[
              Container(
                width: 450,
                height: 400,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 6 / 6,
                  ),
                  itemCount: 28,
                  itemBuilder: (ctx, index) {
                   return buildDan(index+1);
                  },
                ),
              ),
            ],
          );
        });
      
      if(s!=null) {
        Provider.of<KategorijaLista>(context,listen:false).updateMjesecnoDodavanjeKategorije(widget.kategorija.id, s);
      }
    
  
  }

  @override
  void initState() {
    planiranePotrosnjeFuture =
        Provider.of<PotrosnjaLista>(context, listen: false)
            .fetchAndSetPlaniranePotrosnje();
    super.initState();
  }

  Widget buildDan(int broj) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(broj);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
        height: 30,
        width: 30,
        child: GridTile(
          child: Container(
            alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: AutoSizeText(broj.toString(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.bold),
                        minFontSize: 15,
                    ),
              ),
          // footer: Container(
          //     alignment: Alignment.center,
          //     child: FittedBox(
          //                     child: Text(
          //         long,
          //         style: TextStyle(color: Colors.white, fontSize: 19),
          //       ),
          //     ),
          //     color: Colors.black54),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planiranePotrosnjeData = Provider.of<PotrosnjaLista>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.work),
            SizedBox(width: 5),
            Text('Planirane potrošnje'),
          ],
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 5, bottom: 5),
              child: CircleAvatar(
                radius: 25,
                backgroundImage:
                    widget.kategorija.slikaUrl == 'assets/images/nema-slike.jpg'
                        ? AssetImage(widget.kategorija.slikaUrl)
                        : MemoryImage(
                            widget.kategorija.slikaEncoded,
                          ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Column(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Lato',
                              color: Colors.black),
                          children: [
                        TextSpan(
                          text: 'Dodaj potrošnje za kategoriju ',
                        ),
                        TextSpan(
                            text: '${widget.kategorija.naziv}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange)),
                        TextSpan(
                          text:
                              ' koje će se dodavati automatski na postavljeni dan svakog mjeseca.',
                        ),
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                          future: planiranePotrosnjeFuture,
                          builder: (ctx, snapshot) {
                            return RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontFamily: 'Raleway',
                                        color: Colors.grey[800]),
                                    children: [
                                  TextSpan(text: 'Dan dodavanja: '),
                                  TextSpan(
                                      text:
                                          '${widget.kategorija.mjesecnoDodavanje}.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))
                                ]));
                          }),
                      FlatButton(
                          onPressed: _izaberiDan,
                          child: Text(
                            'Promijeni',
                            style: TextStyle(
                                fontFamily: 'Lato', color: Colors.orange),
                          ))
                    ],
                  ),
                ),
                Divider(
                  color: Colors.orange,
                  thickness: 2,
                ),
              ]),
            ),
            Flexible(
                flex: 2,
                child: Container(
                    height: min(
                        planiranePotrosnjeData
                                .dobijPlaniranePotrosnje(widget.kategorija.id)
                                .length *
                            80.0,
                        double.infinity),
                    child: FutureBuilder(
                      future: planiranePotrosnjeFuture,
                      builder: (ctx, p) => ListView.builder(
                          itemCount: planiranePotrosnjeData
                              .dobijPlaniranePotrosnje(widget.kategorija.id)
                              .length,
                          itemBuilder: (ctx, index) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  height: 80,
                                  child: Card(
                                    elevation: 3,
                                    child: ListTile(
                                        // onTap: () {
                                        //   showDialog(context: context, builder: (ctx) {
                                        //     return PrikaziPotrosnju(potrosnja: planiranePotrosnjeData.dobijPlaniranePotrosnje(widget.kategorija.id)[index]);
                                        //   });
                                        // },
                                        leading: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                            child: Text(
                                              '${planiranePotrosnjeData.dobijPlaniranePotrosnje(widget.kategorija.id)[index].trosak.toStringAsFixed(0)} KM',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            )),
                                        title: Text(
                                          planiranePotrosnjeData
                                              .dobijPlaniranePotrosnje(
                                                  widget.kategorija.id)[index]
                                              .naziv,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              planiranePotrosnjeData
                                                  .izbrisiPlaniranuPotrosnju(
                                                      planiranePotrosnjeData
                                                          .dobijPlaniranePotrosnje(
                                                              widget.kategorija
                                                                  .id)[index]
                                                          .id);
                                            })),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pocniDodavatPotrosnje(context),
        child: Icon(Icons.add, size: 35),
        backgroundColor: Colors.orange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
