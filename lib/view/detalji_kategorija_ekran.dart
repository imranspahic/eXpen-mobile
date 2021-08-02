import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/salaryNotifier.dart';
import 'package:expen/providers/settingsNotifier.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/categoryNotifier.dart';
import '../providers/expenseCategoryNotifier.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:expen/models/Expense.dart';

class DetaljiKategorijaEkran extends StatefulWidget {
  @override
  _DetaljiKategorijaEkranState createState() => _DetaljiKategorijaEkranState();
}

class _DetaljiKategorijaEkranState extends State<DetaljiKategorijaEkran> {
  Future rashodFuture;
  double ukupnoPotroseno = 0.0;
  bool isExpanded = false;
  String trenutnaVrijednostDropdown =
      DateFormat.MMMM().format(DateTime.now()).toString();

  // double ostalo(int index) {
  //   final CategoryNotifier categoryNotifier = Provider.of<KategorijaLista>(context, listen: false);
  //   final SubcategoryNotifier subcategoryNotifier subcategoryNotifier = Provider.of<PotrosnjaLista>(context, listen: false);

  //   double first = categoryNotifier.kategorijaLista[index].rashodGodina;
  //   double second =
  //       subcategoryNotifier.trosakPoKategoriji(categoryNotifier.kategorijaLista[index].id);

  //   return first - second;
  // }

  String dobijUkupnoPotroseno(String mjesec) {
    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(context, listen: false);

    List<Expense> filterovanaLista;

    filterovanaLista = expenseNotifier.expenses.where((item) {
      var vrijednostMjesec = item.datum.month;
      String vrijednostString;
      switch (vrijednostMjesec) {
        case 1:
          vrijednostString = 'Januar';
          break;
        case 2:
          vrijednostString = 'Februar';
          break;
        case 3:
          vrijednostString = 'Mart';
          break;
        case 4:
          vrijednostString = 'April';
          break;
        case 5:
          vrijednostString = 'Maj';
          break;
        case 6:
          vrijednostString = 'Juni';
          break;
        case 7:
          vrijednostString = 'Juli';
          break;
        case 8:
          vrijednostString = 'August';
          break;
        case 9:
          vrijednostString = 'Septembar';
          break;
        case 10:
          vrijednostString = 'Oktobar';
          break;
        case 11:
          vrijednostString = 'Novembar';
          break;
        case 12:
          vrijednostString = 'Decembar';
          break;

        default:
      }
      return vrijednostString == mjesec;
    }).toList();
    double ukupniTrosak = 0;
    for (int i = 0; i < filterovanaLista.length; i++) {
      ukupniTrosak = ukupniTrosak + filterovanaLista[i].trosak;
    }
    trosakSecond = ukupniTrosak;
    return ukupniTrosak.toStringAsFixed(2);
  }

  double trosakFirst;
  double dobijVrijednost(String vrijednostDropdown) {
    final svekatData = Provider.of<SettingsNotifier>(context, listen: false);
    trosakFirst = svekatData.rashodSveKategorijeMapa[vrijednostDropdown];
    final plataData = Provider.of<SalaryNotifier>(context, listen: false);
    return plataData.dobijPlatuPoMjesecu(vrijednostDropdown);
    // return svekatData.rashodSveKategorijeMapa[vrijednostDropdown];
  }

  String formatirajMjesecNaBosanski(trenutaVrijednostDropdown) {
    switch (trenutnaVrijednostDropdown) {
      case 'January':
        trenutnaVrijednostDropdown = 'Januar';
        break;
      case 'February':
        trenutnaVrijednostDropdown = 'Februar';
        break;
      case 'March':
        trenutnaVrijednostDropdown = 'Mart';
        break;

      case 'April':
        trenutnaVrijednostDropdown = 'April';
        break;
      case 'May':
        trenutnaVrijednostDropdown = 'Maj';
        break;
      case 'June':
        trenutnaVrijednostDropdown = 'Juni';
        break;
      case 'July':
        trenutnaVrijednostDropdown = 'Juli';
        break;
      case 'August':
        trenutnaVrijednostDropdown = 'August';
        break;
      case 'September':
        trenutnaVrijednostDropdown = 'Septembar';
        break;
      case 'October':
        trenutnaVrijednostDropdown = 'Oktobar';
        break;
      case 'November':
        trenutnaVrijednostDropdown = 'Novembar';
        break;
      case 'December':
        trenutnaVrijednostDropdown = 'Decembar';
        break;

      default:
    }

    return trenutnaVrijednostDropdown;
  }

  int potrosnjeMjesec(String mjesec, int index) {
    final expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);
    final CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context, listen: false);
    List<Expense> potrosnjeKategorija = [];
    potrosnjeKategorija = expenseNotifier.expenses
        .where((element) =>
            element.idKategorije == categoryNotifier.kategorijaLista[index].id)
        .toList();
    List<Expense> filterovanaLista;

    filterovanaLista = potrosnjeKategorija.where((item) {
      var vrijednostMjesec = item.datum.month;
      String vrijednostString;
      switch (vrijednostMjesec) {
        case 1:
          vrijednostString = 'Januar';
          break;
        case 2:
          vrijednostString = 'Februar';
          break;
        case 3:
          vrijednostString = 'Mart';
          break;
        case 4:
          vrijednostString = 'April';
          break;
        case 5:
          vrijednostString = 'Maj';
          break;
        case 6:
          vrijednostString = 'Juni';
          break;
        case 7:
          vrijednostString = 'Juli';
          break;
        case 8:
          vrijednostString = 'August';
          break;
        case 9:
          vrijednostString = 'Septembar';
          break;
        case 10:
          vrijednostString = 'Oktobar';
          break;
        case 11:
          vrijednostString = 'Novembar';
          break;
        case 12:
          vrijednostString = 'Decembar';
          break;

        default:
      }
      return vrijednostString == mjesec;
    }).toList();

    return filterovanaLista.length;
  }

  double razlika() {
    return Provider.of<ExpenseCategoryNotifier>(context, listen: false)
            .dobijRashodSvihKategorijaPoMjesecu(trenutnaVrijednostDropdown) -
        trosakSecond;
  }

  double trosakSecond;

  String trosakMjesec(String mjesec, int index) {
    final expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);
    final CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context, listen: false);
    List<Expense> potrosnjeKategorija = [];
    potrosnjeKategorija = expenseNotifier.expenses
        .where((element) =>
            element.idKategorije == categoryNotifier.kategorijaLista[index].id)
        .toList();

    List<Expense> filterovanaLista;

    filterovanaLista = potrosnjeKategorija.where((item) {
      var vrijednostMjesec = item.datum.month;
      String vrijednostString;
      switch (vrijednostMjesec) {
        case 1:
          vrijednostString = 'Januar';
          break;
        case 2:
          vrijednostString = 'Februar';
          break;
        case 3:
          vrijednostString = 'Mart';
          break;
        case 4:
          vrijednostString = 'April';
          break;
        case 5:
          vrijednostString = 'Maj';
          break;
        case 6:
          vrijednostString = 'Juni';
          break;
        case 7:
          vrijednostString = 'Juli';
          break;
        case 8:
          vrijednostString = 'August';
          break;
        case 9:
          vrijednostString = 'Septembar';
          break;
        case 10:
          vrijednostString = 'Oktobar';
          break;
        case 11:
          vrijednostString = 'Novembar';
          break;
        case 12:
          vrijednostString = 'Decembar';
          break;

        default:
      }
      return vrijednostString == mjesec;
    }).toList();
    double ukupniTrosak = 0;
    for (int i = 0; i < filterovanaLista.length; i++) {
      ukupniTrosak = ukupniTrosak + filterovanaLista[i].trosak;
    }

    return ukupniTrosak.toStringAsFixed(2);
  }

  Widget buildRashod(
      String title, String vrijednost, TextStyle style, bool minusTrue) {
    return Container(
      margin: EdgeInsets.only(top: 0),
      alignment: Alignment.center,
      width: 400,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 22),
                  textAlign: TextAlign.center),
              minusTrue
                  ? Text(
                      '-$vrijednost KM',
                      style: style,
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      '$vrijednost KM',
                      style: style,
                      textAlign: TextAlign.center,
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, int index) {
    final CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context, listen: false);

    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 5.0, top: 10, right: 5),
        child: Column(children: <Widget>[
          Container(
            width: 150,
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: categoryNotifier.kategorijaLista[index].slikaUrl ==
                          'assets/images/nema-slike.jpg'
                      ? AssetImage(categoryNotifier.kategorijaLista[index].slikaUrl)
                      : MemoryImage(
                          categoryNotifier.kategorijaLista[index].slikaEncoded),
                  radius: 70,
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: FittedBox(
                    child: Container(
                      height: 40,
                      width: 140,
                      color: Colors.black87,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          child: Text(
                            categoryNotifier.kategorijaLista[index].naziv,
                            style: TextStyle(
                                fontSize: 28, color: Colors.orange[100]),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              height: 70,
              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: Card(
                child: Container(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          width: 80,
                          child: Row(children: <Widget>[
                            Icon(Icons.work, color: Colors.orange, size: 30),
                            SizedBox(width: 8),
                            Text(
                              potrosnjeMjesec(trenutnaVrijednostDropdown, index)
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 25, color: Colors.brown[400]),
                            )
                          ])),
                      SizedBox(width: 20),
                      Container(
                          alignment: Alignment.center,
                          width: min(
                              trosakMjesec(trenutnaVrijednostDropdown, index)
                                          .length *
                                      20.0 +
                                  trosakMjesec(
                                          trenutnaVrijednostDropdown, index)
                                      .length +
                                  10,
                              250),
                          child: Row(children: <Widget>[
                            Icon(Icons.monetization_on,
                                color: Colors.purple, size: 30),
                            SizedBox(width: 8),
                            Text(
                              '${trosakMjesec(trenutnaVrijednostDropdown, index)}',
                              style: TextStyle(
                                  fontSize: 25, color: Colors.brown[400]),
                            ),
                          ])),
                    ],
                  ),
                ),
              ))
        ]),
      ),
      SizedBox(
        height: 15,
      ),
      Divider(thickness: 1)
    ]);
  }

  @override
  void initState() {
    rashodFuture = Provider.of<SettingsNotifier>(context, listen: false)
        .fetchAndSetRashod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[700],
          title: Row(children: <Widget>[
            Icon(
              Icons.more,
              color: Colors.blue[50],
            ),
            SizedBox(width: 10),
            Text(
              'Detalji',
              style: TextStyle(color: Colors.blue[50]),
            )
          ]),
        ),
        body: FutureBuilder(
          future: rashodFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                  child: Column(children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.check_circle),
                          SizedBox(width: 6),
                          Center(
                              child: Text(
                            'Sve kategorije',
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Lato',
                                color: Colors.brown),
                          ))
                        ])),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.blue[700],
                  margin:
                      EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
                  child: ListTile(
                    trailing: DropdownButton<String>(
                      value: formatirajMjesecNaBosanski(
                          trenutnaVrijednostDropdown),
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 9,
                      iconEnabledColor: Colors.white,
                      dropdownColor: Colors.black54,
                      focusColor: Colors.white,
                      style: TextStyle(color: Colors.yellow, fontSize: 30),
                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          trenutnaVrijednostDropdown = newValue;
                        });
                      },
                      items: <String>[
                        'Januar',
                        'Februar',
                        'Mart',
                        'April',
                        'Maj',
                        'Juni',
                        'Juli',
                        'August',
                        'Septembar',
                        'Oktobar',
                        'Novembar',
                        'Decembar'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              // color: Colors.brown[700],
                              fontFamily: 'Lato',
                              fontSize: 18,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    leading: Text(
                      'Prikaži po mjesecu',
                      style: TextStyle(
                          fontSize: 21,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                          color: Colors.blue[50]),
                    ),
                  ),
                ),
                Container(
                  height: categoryNotifier.kategorijaLista.length * 150.0 +
                      categoryNotifier.kategorijaLista.length * 100 +
                      categoryNotifier.kategorijaLista.length * 10,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: Provider.of<CategoryNotifier>(context)
                        .kategorijaLista
                        .length,
                    itemBuilder: (ctx, index) {
                      return buildCard(context, index);
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Prihod za ${trenutnaVrijednostDropdown.toLowerCase()}',
                                  style: TextStyle(
                                      fontFamily: 'Lato', fontSize: 18),
                                ),
                                Text(
                                  '${dobijVrijednost(trenutnaVrijednostDropdown).toStringAsFixed(2)} KM',
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 20,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Rashod za ${trenutnaVrijednostDropdown.toLowerCase()}',
                                  style: TextStyle(
                                      fontFamily: 'Lato', fontSize: 18),
                                ),
                                Text(
                                  '${Provider.of<ExpenseCategoryNotifier>(context, listen: false).dobijRashodSvihKategorijaPoMjesecu(trenutnaVrijednostDropdown).toStringAsFixed(2)} KM',
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 20,
                                      color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Ukuno potrošeno ',
                                  style: TextStyle(
                                      fontSize: 18, fontFamily: 'Lato'),
                                ),
                                Text(
                                  '${dobijUkupnoPotroseno(trenutnaVrijednostDropdown)} KM',
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 20,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (Provider.of<ExpenseCategoryNotifier>(context,
                                        listen: false)
                                    .dobijRashodSvihKategorijaPoMjesecu(
                                        trenutnaVrijednostDropdown) >
                                dobijVrijednost(trenutnaVrijednostDropdown) &&
                            dobijVrijednost(trenutnaVrijednostDropdown) != 0)
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.warning,
                                      size: 30, color: Colors.white),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 260,
                                    child: AutoSizeText(
                                      'Planirani rashod veći od plate za ${(Provider.of<ExpenseCategoryNotifier>(context, listen: false).dobijRashodSvihKategorijaPoMjesecu(trenutnaVrijednostDropdown) - dobijVrijednost(trenutnaVrijednostDropdown)).toStringAsFixed(2)} KM',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      minFontSize: 16,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Lato',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                razlika() < 0
                                    ? Text(
                                        '${razlika().toStringAsFixed(2)} KM',
                                        style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 25,
                                            color: Colors.red),
                                      )
                                    : razlika() == 0
                                        ? Text(
                                            '${razlika().toStringAsFixed(2)} KM',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 25,
                                                color: Colors.grey),
                                          )
                                        : Text(
                                            '+${razlika().toStringAsFixed(2)} KM',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 25,
                                                color: Colors.green),
                                          ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))
              ]));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
