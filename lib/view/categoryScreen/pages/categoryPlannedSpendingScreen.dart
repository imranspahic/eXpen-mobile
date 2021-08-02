import 'package:expen/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/providers/expenseNotifier.dart';
import '../../../providers/expenseCategoryNotifier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expen/models/Expense.dart';

class CategoryPlannedSpendingScreen extends StatefulWidget {
  final Category kategorija;
  final List<Expense> dostupnePotrosnje;
  CategoryPlannedSpendingScreen(this.kategorija, this.dostupnePotrosnje);
  @override
  _CategoryPlannedSpendingScreenState createState() => _CategoryPlannedSpendingScreenState();
}

class _CategoryPlannedSpendingScreenState extends State<CategoryPlannedSpendingScreen> {
  String trenutnaVrijednostDropdown =
      DateFormat.MMMM().format(DateTime.now()).toString();

  List<Expense> get dostupnePotrosnjeUCijelojKategoriji {
    final ExpenseNotifier expenseNotifier = Provider.of<ExpenseNotifier>(context);
    return expenseNotifier.listaSvihPotrosnji.where((item) {
      return item.idKategorije == widget.kategorija.id;
    }).toList();
  }

  double get dobijUkupniTrosak {
    double ukupniTrosak = 0;
    for (int i = 0; i < widget.dostupnePotrosnje.length; i++) {
      ukupniTrosak = ukupniTrosak + widget.dostupnePotrosnje[i].trosak;
    }

    return ukupniTrosak;
  }

  double get ostalo {
    Provider.of<CategoryNotifier>(context).rashodMjesec(
        dobijVrijednost(trenutnaVrijednostDropdown),
        double.parse(trosakMjesec(trenutnaVrijednostDropdown)));
    return dobijVrijednost(trenutnaVrijednostDropdown) -
        double.parse(trosakMjesec(trenutnaVrijednostDropdown));
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

  String trosakMjesec(String mjesec) {
    List<Expense> filterovanaLista;

    filterovanaLista = widget.dostupnePotrosnje.where((item) {
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

  String dobijNaziv(String vrijednostDropdown) {
    List<String> keys = widget.kategorija.mapaRashoda.keys.toList();
    String naziv = keys.singleWhere((element) => element == vrijednostDropdown);
    return naziv;
  }

  double dobijVrijednost(String vrijednostDropdown) {
    return Provider.of<ExpenseCategoryNotifier>(context, listen: false)
        .dobijRashodKategorijePoMjesecu(
            widget.kategorija.id, trenutnaVrijednostDropdown);
  }

  Widget buildRashod(
      String title, String vrijednost, TextStyle style, bool minusTrue) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      alignment: Alignment.center,
      width: 400,
      child: Card(
        child: FittedBox(
          child: Container(
            width: MediaQuery.of(context).size.width,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Rashod: ${widget.kategorija.naziv}'),
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
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.orange[300],
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 20),
              child: ListTile(
                trailing: DropdownButton<String>(
                  value: formatirajMjesecNaBosanski(trenutnaVrijednostDropdown),
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 9,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
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
                          color: Colors.brown[700],
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
                      color: Colors.brown[700]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: Container(
                    height: 100,
                    child: CircleAvatar(
                      backgroundImage: widget.kategorija.slikaUrl ==
                              'assets/images/nema-slike.jpg'
                          ? AssetImage(widget.kategorija.slikaUrl)
                          : MemoryImage(
                              widget.kategorija.slikaEncoded,
                            ),
                      radius: 30,
                    )),
                title: Text(widget.kategorija.naziv),
                trailing: Text(
                  '${dobijVrijednost(trenutnaVrijednostDropdown).toStringAsFixed(0)} KM ',
                  style: ostalo == 0
                      ? TextStyle(fontSize: 30, color: Colors.grey)
                      : TextStyle(fontSize: 30, color: Colors.green),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
              child: Divider(
                thickness: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            buildRashod(
                'Planirano',
                dobijVrijednost(trenutnaVrijednostDropdown).toStringAsFixed(0),
                TextStyle(fontSize: 22, color: Colors.green),
                false),
            buildRashod('Potrošeno', trosakMjesec(trenutnaVrijednostDropdown),
                TextStyle(fontSize: 22, color: Colors.red), true),
            Container(
                padding: EdgeInsets.only(top: 80),
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 50,
                          color: ostalo < 0
                              ? Colors.red
                              : ostalo == 0
                                  ? Colors.grey
                                  : Colors.green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ostalo < 0
                            ? Text(
                                '${ostalo.toStringAsFixed(2)} KM',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 50),
                              )
                            : ostalo == 0
                                ? Text(
                                    '${ostalo.toStringAsFixed(2)} KM',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 50),
                                  )
                                : Text(
                                    '+${ostalo.toStringAsFixed(2)} KM',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 50),
                                  )
                      ],
                    ),
                  ),
                )),
          ]),
        ));
  }
}
