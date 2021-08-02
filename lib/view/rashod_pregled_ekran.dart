import 'package:expen/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/expenseCategoryNotifier.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RashodPregledEkran extends StatefulWidget {
  @override
  _RashodPregledEkranState createState() => _RashodPregledEkranState();
}

class _RashodPregledEkranState extends State<RashodPregledEkran> {
  Future rashodKategorijaFuture;
  String trenutnaVrijednostDropdown =
      DateFormat.MMMM().format(DateTime.now()).toString();

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

  @override
  void initState() {
    rashodKategorijaFuture =
        Provider.of<ExpenseCategoryNotifier>(context, listen: false)
            .fetchAndSetRashodKategorija();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context, listen: false);
    final rashodKatData = Provider.of<ExpenseCategoryNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[400],
        title: Row(
          children: [
            Icon(Icons.flag, color: Colors.black),
            SizedBox(width: 10),
            Text(
              'Rashod',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.deepOrange[400],
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
            child: ListTile(
              trailing: DropdownButton<String>(
                value: formatirajMjesecNaBosanski(trenutnaVrijednostDropdown),
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 9,
                iconEnabledColor: Colors.brown,
                dropdownColor: Colors.deepOrange.withOpacity(0.7),
                focusColor: Colors.black,
                style: TextStyle(color: Colors.yellow[300], fontSize: 30),
                underline: Container(
                  height: 2,
                  color: Colors.brown[400],
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
                    color: Colors.black),
              ),
            ),
          ),
          FutureBuilder(
              future: rashodKategorijaFuture,
              builder: (ctx, snapshot) {
                return Container(
                  height: categoryNotifier.kategorijaLista.length * 70.0 +
                      categoryNotifier.kategorijaLista.length * 15 +
                      categoryNotifier.kategorijaLista.length * 10,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: categoryNotifier.kategorijaLista.length,
                      itemBuilder: (ctx, index) {
                        return KategorijaWidget(
                          kategorija: categoryNotifier.kategorijaLista[index],
                          mjesec: trenutnaVrijednostDropdown,
                        );
                      }),
                );
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 20, top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 2,
                        child: AutoSizeText(
                          'Ukupan rashod za mjesec $trenutnaVrijednostDropdown',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        child: AutoSizeText(
                          '${rashodKatData.dobijRashodSvihKategorijaPoMjesecu(trenutnaVrijednostDropdown).toStringAsFixed(2)} KM',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontFamily: 'RobotoCondense',
                            fontSize: 20,
                            color:Colors.deepOrange,
                            fontWeight: FontWeight.bold
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class KategorijaWidget extends StatelessWidget {
  final Category kategorija;
  final String mjesec;
  KategorijaWidget({this.kategorija, this.mjesec});
  @override
  Widget build(BuildContext context) {
    final rashodKatData =
        Provider.of<ExpenseCategoryNotifier>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage:
                  kategorija.slikaUrl == 'assets/images/nema-slike.jpg'
                      ? AssetImage(kategorija.slikaUrl)
                      : MemoryImage(
                          kategorija.slikaEncoded,
                        ),
            ),
            title: Text(kategorija.naziv),
            trailing: Text(
              '${rashodKatData.dobijRashodKategorijePoMjesecu(kategorija.id, mjesec).toStringAsFixed(2)} KM',
              style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  color: Colors.deepOrange,
                  fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
