
import 'package:flutter/material.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GrafoviKategorijaEkran extends StatefulWidget {
  final CategoryModel kategorijaLista;
  final List<ExpenseModel> dostupnePotrosnje;
  final String title;
  final bool uPotkategoriji;
  final SubcategoryModel potKategorija;
  final List<SubcategoryModel> dostupnePotkategorije;

  GrafoviKategorijaEkran(
      {this.kategorijaLista,
      this.dostupnePotrosnje,
      this.title,
      this.uPotkategoriji,
      this.potKategorija,
      this.dostupnePotkategorije});

  @override
  _GrafoviKategorijaEkranState createState() => _GrafoviKategorijaEkranState();
}

class _GrafoviKategorijaEkranState extends State<GrafoviKategorijaEkran> {
  String trenutnaVrijednostDropdown =
      DateFormat.MMMM().format(DateTime.now()).toString();

  double get dobijUkupniTrosak {
    double ukupniTrosak = 0;
    for (int i = 0; i < widget.dostupnePotrosnje.length; i++) {
      ukupniTrosak = ukupniTrosak + widget.dostupnePotrosnje[i].trosak;
    }

    return ukupniTrosak;
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

  int potrosnjeMjesec(String mjesec) {
    List<ExpenseModel> filterovanaLista;

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

    return filterovanaLista.length;
  }

  String trosakMjesec(String mjesec) {
    List<ExpenseModel> filterovanaLista;

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

  List<double> postotakMjesec(String mjesec) {
    List<ExpenseModel> filterovanaLista;

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

    List<double> postotci = [];
    var postotak = 0.0;
    postotak = filterovanaLista.length / widget.dostupnePotrosnje.length;
    var ukupnipostotak = 1 - postotak;
    if (postotak > 0) {
      postotci.add(postotak * 100);
    } else
      postotci.add(0);
    if (ukupnipostotak < 1) {
      postotci.add(ukupnipostotak * 100);
    } else
      postotci.add(0);

    return postotci;
  }

  Map<String, double> dataMap = new Map();
  Map<String, int> mapa;
  List<String> list = [];
  List<double> val = [];
  List<Color> col = [];

  List<String> convert() {
    //  Map<String, int> map = new Map.fromIterable(widget.dostupnePotkategorije,
    //  key: (item) => item.naziv.toString(),
    //  value: (item) => 5);

    widget.dostupnePotkategorije.forEach((f) => list.add(f.naziv));
    return list;
  }

  List<double> convert2() {
    final potKatData = Provider.of<SubcategoryNotifier>(context);

    for (var i = 0; i < widget.dostupnePotkategorije.length; i++) {
      List<ExpenseModel> pocetna = [];
      pocetna = potKatData.dostPotKat.where((test) {
        return test.idPotKategorije == widget.dostupnePotkategorije[i].idPot;
      }).toList();

      val.add(pocetna.length.toDouble());
    }
    return val;
  }

  Map<String, double> convert3() {
    convert();
    convert2();
    Map<String, double> map = new Map.fromIterables(list, val);
    return map;
  }

  List<Color> convert4() {
    for (int i = 0; i < widget.dostupnePotkategorije.length; i++) {
      col.add(widget.dostupnePotkategorije[i].bojaIkone);
    }
    return col;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, widget.dostupnePotrosnje);
        return;
      },
      child: Scaffold(
          appBar: AppBar(
            title: widget.title == ''
                ? Text(widget.kategorijaLista.naziv)
                : Text('${widget.kategorijaLista.naziv}: ${widget.title}'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, widget.dostupnePotrosnje),
            ),
              actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 5, bottom: 5),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: widget.kategorijaLista.slikaUrl == 'assets/images/nema-slike.jpg' ? AssetImage(widget.kategorijaLista.slikaUrl) : MemoryImage(widget.kategorijaLista.slikaEncoded,),),
            )
          ],
          ),
          body: SingleChildScrollView(
            child: Column(children: <Widget>[
              widget.uPotkategoriji == true
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: Icon(
                          IconData(widget.potKategorija.icon,
                              fontFamily: 'MaterialIcons'),
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
                        subtitle: Divider(
                            color: Colors.orange, height: 10, thickness: 2),
                      ),
                    )
                  : Container(),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.orange[300],
                margin:
                    EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 20),
                child: ListTile(
                  trailing: DropdownButton<String>(
                    value:
                        formatirajMjesecNaBosanski(trenutnaVrijednostDropdown),
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
              Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.orange),
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  height: 400,
                  padding: EdgeInsets.all(5),

                  //KOLONA U CARD ZA MJESEC
                  child: Column(children: <Widget>[
                    Text(
                      trenutnaVrijednostDropdown,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),

                    // JEDAN RED U KOLONI ZA MJESEC
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //UKUPNO POTROŠNJI U MJESECU
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black38),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(3),
                              child: FittedBox(
                                child: Text(
                                  'Ukupno potrošnji',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: Text(
                                potrosnjeMjesec(trenutnaVrijednostDropdown)
                                    .toString(),
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ]),
                        ),

                        //TROŠAK U MJESECU
                        Expanded(
                          child: Container(
                            height: 130,
                            margin: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black38),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(3),
                                child: Text(
                                  'Ukupni trošak',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.only(bottom: 5),
                                child: FittedBox(
                                  child: Text(
                                    '${trosakMjesec(trenutnaVrijednostDropdown)} KM',
                                    style: TextStyle(
                                        fontSize: 39, color: Colors.red),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(15),
                          child: PieChart(
                            dataMap: {
                              '$trenutnaVrijednostDropdown':
                                  postotakMjesec(trenutnaVrijednostDropdown)[0],
                              'Ostalo':
                                  postotakMjesec(trenutnaVrijednostDropdown)[1],
                            },
                            animationDuration: Duration(milliseconds: 4000),
                            chartLegendSpacing: 30.0,
                            chartRadius:
                                MediaQuery.of(context).size.width / 2.7,
                            showChartValuesInPercentage: true,
                            showChartValues: true,
                            showChartValuesOutside: false,
                            chartValueBackgroundColor: Colors.grey[200],
                            colorList: [
                              widget.potKategorija != null
                                  ? widget.potKategorija.bojaIkone
                                  : Colors.red,
                              widget.potKategorija != null &&
                                      widget.potKategorija.bojaIkone ==
                                          Color(0xff9e9e9e)
                                  ? Colors.orange
                                  : Colors.grey[500]
                            ],
                            showLegends: true,
                            legendPosition: LegendPosition.right,
                            decimalPlaces: 1,
                            showChartValueLabel: true,
                            initialAngle: 2,
                            chartValueStyle: defaultChartValueStyle.copyWith(
                              fontSize: 15,
                              color: Colors.blueGrey[900].withOpacity(0.9),
                            ),
                            legendStyle:
                                defaultLegendStyle.copyWith(fontSize: 15),
                            chartType: ChartType.ring,
                          ),
                        ),
                        //UKUPNO Postotak
                      ],
                    ),
                  ]),
                ),
              ),

              // pie chart ZA POTKATEGORIJE ...
              // OVDJE
              //...
              //..
              //...
              widget.dostupnePotkategorije != null
                  ? Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(width: 3, color: Colors.orange),
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        height: widget.dostupnePotkategorije.length.toDouble() *
                                50.0 +
                            300.0,

                        padding: EdgeInsets.all(5),

                        //KOLONA U CARD ZA MJESEC
                        child: Column(children: <Widget>[
                          Text(
                            'Potkategorije',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),

                          // JEDAN RED U KOLONI ZA MJESEC
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //TROŠAK U MJESECU
                              Expanded(
                                child: Container(
                                  height: widget.dostupnePotkategorije.length
                                          .toDouble() *
                                      50.0,
                                  margin: EdgeInsets.only(top: 15),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black38),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          widget.dostupnePotkategorije.length,
                                      itemBuilder: (ctx, index) {
                                        return ListTile(
                                          leading: Icon(
                                            IconData(
                                                widget
                                                    .dostupnePotkategorije[
                                                        index]
                                                    .icon,
                                                fontFamily: 'MaterialIcons'),
                                            size: 30,
                                            color: widget
                                                .dostupnePotkategorije[index]
                                                .bojaIkone,
                                          ),
                                          title: Container(
                                              width: 100,
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              child: FittedBox(
                                                  child: Text(
                                                      widget
                                                          .dostupnePotkategorije[
                                                              index]
                                                          .naziv,
                                                      style: TextStyle(
                                                          fontSize: 30)))),
                                          subtitle: Divider(
                                              color: widget.dostupnePotkategorije[index].bojaIkone,
                                              height: 10,
                                              thickness: 2),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                          widget.dostupnePotkategorije.isEmpty
                              ? Container(
                                  padding: EdgeInsets.only(top: 50),
                                  width: 300,
                                  height: 150,
                                  child: Column(children: <Widget>[
                                    Icon(Icons.not_interested, size: 45),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text(
                                        'Nema dodanih potkategorija',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ]),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10,
                                          bottom: 10,
                                          top: 40,
                                          right: 10),
                                      child: Container(
                                        width: 330,
                                        child: PieChart(
                                          dataMap: convert3(),
                                          animationDuration:
                                              Duration(milliseconds: 4000),
                                          chartLegendSpacing: 30.0,
                                          chartRadius: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.7,
                                          showChartValuesInPercentage: true,
                                          showChartValues: true,
                                          showChartValuesOutside: false,
                                          chartValueBackgroundColor:
                                              Colors.grey[200],
                                          colorList: convert4(),
                                          // widget.potKategorija != null
                                          //     ? widget.potKategorija.bojaIkone
                                          //     : Colors.red,
                                          // widget.potKategorija != null &&
                                          //         widget.potKategorija.bojaIkone ==
                                          //             Color(0xff9e9e9e)
                                          //     ? Colors.orange
                                          //     : Colors.grey[500]

                                          showLegends: true,
                                          legendPosition: LegendPosition.right,
                                          decimalPlaces: 1,
                                          showChartValueLabel: true,
                                          initialAngle: 2,
                                          chartValueStyle:
                                              defaultChartValueStyle.copyWith(
                                            fontSize: 14,
                                            color: Colors.blueGrey[900]
                                                .withOpacity(0.9),
                                          ),
                                          legendStyle: defaultLegendStyle
                                              .copyWith(fontSize: 17),
                                          chartType: ChartType.ring,
                                        ),
                                      ),
                                    ),
                                    //UKUPNO Postotak
                                  ],
                                ),
                        ]),
                      ),
                    )
                  : Container(),

              // UKUPNO POTROSNJI SA PRIKAZOM NA DNU ...
              // OVDJE
              //...
              //..
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 20),
                decoration: BoxDecoration(
                    border: Border.all(width: 6, color: Colors.orange),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange[500]),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                  child: Container(
                    child: Column(children: <Widget>[
                      Container(
                          width: 280,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Text(
                            'Ukupno potrošnji',
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 0, top: 10),
                          child: Text(
                            widget.dostupnePotrosnje.length.toString(),
                            style: TextStyle(
                                fontSize: 40,
                                color: Theme.of(context).primaryColor,
                                letterSpacing: 5),
                          )),
                      // Container(
                      //     margin: EdgeInsets.only(left: 5,),
                      //     child: Icon(Icons.arrow_forward, size: 25)),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 250,
                        padding: EdgeInsets.all(15),
                        child: FittedBox(
                          child: Text(
                            '${dobijUkupniTrosak.toStringAsFixed(2)} KM',
                            style:
                                TextStyle(fontSize: 50, color: Colors.red[300]),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
