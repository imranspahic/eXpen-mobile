import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/view/dodaj_vise_potrosnji.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../widgets/dodaj_novu_potrosnju.dart';
import 'planirane_potrosnje_ekran.dart';


class PotKategorijaEkran extends StatefulWidget {
  final SubcategoryModel potKategorija;
  final CategoryModel kategorija;

  PotKategorijaEkran(this.potKategorija, this.kategorija);

  @override
  _PotKategorijaEkranState createState() => _PotKategorijaEkranState();
}

class _PotKategorijaEkranState extends State<PotKategorijaEkran> {
  void pocniDodavatPotrosnje(ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (ctx) {
          return DodajNovuPotrosnju(
            kategorija: widget.kategorija,
            potkategorija: widget.potKategorija,
            uPotkategoriji: true,
            jeLiPlaniranaPotrosnja: false,
          );
        });
  }

  
  void otvoriDodavanjeVisePotrosnji(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return DodajVisePotrosnji(
        kategorija: widget.kategorija,
        potkategorija: widget.potKategorija,
        uPotkategoriji: true,
      );
    }));
  }

  void planiranePotrosnje(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return PlaniranePotrosnjeEkran(kategorija: widget.kategorija, potKategorija: widget.potKategorija,);
    }));
  }

  List<ExpenseModel> get dostupnePotrosnjePotkategorija {
    final potrosnjaData = Provider.of<ExpenseNotifier>(context, listen: false);
    final potKatData = Provider.of<SubcategoryNotifier>(context, listen: false);

    return potrosnjaData.listaSvihPotrosnji.where((item) {
      if (item.idKategorije == widget.kategorija.id &&
          item.idPotKategorije == widget.potKategorija.idPot) {
        potKatData.dodajUPotKatList(item);

        return true;
      } else {
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    final potrosnjaData = Provider.of<ExpenseNotifier>(context);
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
            backgroundColor: Colors.yellow[600],
            label: 'Planirane potrošnje',
            labelStyle: TextStyle(fontSize: 18),
            child: Icon(Icons.work, size: 28),
            onTap: () => planiranePotrosnje(context)
          ),
            
          ],
        ),
        appBar: AppBar(
          title:
              Text('${widget.kategorija.naziv}: ${widget.potKategorija.naziv}'),
              actions: <Widget>[
                Stack(children: <Widget>[
                     Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 5, bottom: 5),
              child:
                CircleAvatar(
                  radius: 25,
                  backgroundImage: widget.kategorija.slikaUrl == 'assets/images/nema-slike.jpg' ? AssetImage(widget.kategorija.slikaUrl) : MemoryImage(
                        widget.kategorija.slikaEncoded
                        
                        ),),
              ),
            
            // Positioned(
            //   bottom: 0,
            //   right: 10,
            //   child: Icon(IconData(widget.potKategorija.icon, fontFamily: 'MaterialIcons'), size: 34, color: widget.potKategorija.bojaIkone,))
                ],)
           
          ],
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(
               IconData(widget.potKategorija.icon, fontFamily: 'MaterialIcons'), 
                size: 60,
                color: widget.potKategorija.bojaIkone,
              ),
              title: Container(
                  width: 100,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                      child: Text(widget.potKategorija.naziv,
                          style: TextStyle(fontSize: 40)))),
              subtitle: Divider(color: Colors.orange, height: 10, thickness: 2),
            ),
          ),
          Container(
            height: 450,
            child: ListView.builder(
                itemCount: dostupnePotrosnjePotkategorija.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: <Widget>[
                      Card(
                        elevation: 3,
                        child: ListTile(
                            leading: Container(
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).primaryColor)),
                                child: Text(
                                  '${dostupnePotrosnjePotkategorija[index].trosak.toStringAsFixed(0)} KM',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).accentColor),
                                )),

                            title: dostupnePotrosnjePotkategorija[index].naziv =='' ? Container() : Text(
                                dostupnePotrosnjePotkategorija[index].naziv),
                            subtitle: Text(DateFormat.yMMMd().format(
                                dostupnePotrosnjePotkategorija[index].datum)),
                            trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => potrosnjaData.izbrisiPotrosnju(
                                    dostupnePotrosnjePotkategorija[index].id))),
                      ),
                    ],
                  );
                }),
          ),
        ]));
  }
}
