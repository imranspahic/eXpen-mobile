import 'package:expen/services/dialogServices/showDialogService.dart';
import 'package:expen/services/navigatorServices/navigateToPageService.dart';
import 'package:expen/utils/speedDial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:intl/intl.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'dart:math';
import 'package:expen/providers/subcategoryNotifier.dart';
import '../../../widgets/badge.dart';
import '../../edit_potkategorija_ekran.dart';
import '../../bottomNavigationScreen/pages/subcategoryBottomNavigationScreen.dart';
import 'package:expen/providers/settingsNotifier.dart';
import '../../../widgets/izbrisi_dialog.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel category;
  List<ExpenseModel> dostupnePotrosnje;
  final List<SubcategoryModel> dostupnePotkategorije;
  final bool isDrawer;

  CategoryScreen(
      {this.category,
      this.dostupnePotrosnje,
      this.dostupnePotkategorije,
      this.isDrawer});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Future potrosnjeFuture;
  Future potkategorijeFuture;
  bool listPregled = true;
  bool listPotKategorija = false;

  @override
  Widget build(BuildContext context) {
    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(context);
    final SubcategoryNotifier subcategoryNotifier =
        Provider.of<SubcategoryNotifier>(context, listen: false);
    final postavkeData = Provider.of<SettingsNotifier>(context);
    return Scaffold(
      floatingActionButton: buildSpeedDial(context, widget.category),
      appBar: AppBar(
        title: Text(widget.category.naziv),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 5, bottom: 5),
              child: widget.isDrawer
                  ? CircleAvatar(
                      radius: 25,
                      backgroundImage: widget.category.slikaUrl ==
                              'assets/images/nema-slike.jpg'
                          ? AssetImage(widget.category.slikaUrl)
                          : MemoryImage(
                              widget.category.slikaEncoded,
                            ),
                    )
                  : Hero(
                      tag: widget.category.id,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: widget.category.slikaUrl ==
                                'assets/images/nema-slike.jpg'
                            ? AssetImage(widget.category.slikaUrl)
                            : MemoryImage(
                                widget.category.slikaEncoded,
                              ),
                      ),
                    ))
        ],
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
                          final ExpenseNotifier expenseNotifier =
                              Provider.of<ExpenseNotifier>(context,
                                  listen: false);
                          final List<ExpenseModel> lista =
                              expenseNotifier.potrosnjePoPotkaategorijilista(
                                  widget.dostupnePotkategorije[index].idPot);
                          //izbriši potkategorije
                          subcategoryNotifier.izbrisiPotkategoriju(
                              widget.dostupnePotkategorije[index].idPot, lista);
                          //izbriši potrošnje u potkategoriji
                          expenseNotifier.listaSvihPotrosnji.removeWhere((pot) {
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
                                IconData(
                                    widget.dostupnePotkategorije[index].icon,
                                    fontFamily: 'MaterialIcons'),
                                size: 60,
                                color: widget
                                    .dostupnePotkategorije[index].bojaIkone,
                              ),
                              value: expenseNotifier.badge(
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
                                  await Provider.of<SubcategoryNotifier>(
                                          context,
                                          listen: false)
                                      .fetchAndSetPotkategorije();
                                  setState(() {});
                                });
                              },
                            ),
                            title:
                                Text(widget.dostupnePotkategorije[index].naziv),
                            onTap: () => NavigateToPageService.navigate(
                                context,
                                SubcategoryBottomNavigationScreen(
                                    widget.dostupnePotkategorije[index],
                                    widget.category))),
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
                                          onTap: () => ShowDialogService
                                              .expenseViewDialog(
                                                  context,
                                                  widget.dostupnePotrosnje[
                                                      index]),
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
                                                        izbrisi: expenseNotifier
                                                            .izbrisiPotrosnju,
                                                        potrosnja: widget
                                                                .dostupnePotrosnje[
                                                            index],
                                                      );
                                                    });
                                                // expenseNotifier.izbrisiPotrosnju(
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
