import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/biljeske_provider.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../widgets/izbrisi_dialog.dart';

class BiljeskeEkran extends StatefulWidget {
  @override
  _BiljeskeEkranState createState() => _BiljeskeEkranState();
}

class _BiljeskeEkranState extends State<BiljeskeEkran> {
  Future biljeskeFuture;
  void _dodajNovuBiljesku(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return DodajBiljesku();
        });
  }

  @override
  void initState() {
    biljeskeFuture = Provider.of<BiljeskeLista>(context, listen: false)
        .fetchAndSetBiljeske();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final biljeskeData = Provider.of<BiljeskeLista>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Icon(
              Icons.library_books,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Bilješke',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {})
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
              future: biljeskeFuture,
              builder: (ctx, snapshot) => ListView.builder(
                itemCount: biljeskeData.listaBiljeski.length,
                itemBuilder: (ctx, index) {
                  return BiljeskaWidget(
                      biljeska: biljeskeData.listaBiljeski[index]);
                },
              ),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _dodajNovuBiljesku(context),
        child: Icon(Icons.add_comment, color: Colors.white, size: 30),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class BiljeskaWidget extends StatelessWidget {
  final Biljeska biljeska;

  BiljeskaWidget({this.biljeska});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => PrikazBiljeske(
            biljeska: biljeska,
          ),
        );
      },
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
          BoxShadow(
              color: Colors.red,
              blurRadius: 1,
              offset: Offset(0, 0),
              spreadRadius: -3)
        ]),
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  biljeska.naziv,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Roboto Condensed',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  minFontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          Flexible(
                            flex: 1,
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  DateFormat.yMMMd().format(biljeska.datum),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                )),
                          ),
                        ]),
                  ),
                ),
                SizedBox(width: 20),
                Flexible(
                  flex: 2,
                  child: Container(
                    child: AutoSizeText(
                      biljeska.tekstSadrzaj,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          color: Colors.grey[800]),
                      maxLines: 3,
                      minFontSize: 17,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DodajBiljesku extends StatefulWidget {
  @override
  _DodajBiljeskuState createState() => _DodajBiljeskuState();
}

class _DodajBiljeskuState extends State<DodajBiljesku> {
  DateTime datum;
  TextEditingController _nazivController = TextEditingController();
  TextEditingController _tekstSadrzajController = TextEditingController();

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      setState(() {
        datum = pickedDate;
      });
    });
  }

  void _sacuvajBiljesku() {
    String uneseniNaziv = _nazivController.text;
    String uneseniTekst = _tekstSadrzajController.text;
    if (uneseniTekst.length > 350 ||
        uneseniNaziv.isEmpty ||
        uneseniTekst.isEmpty) {
      return;
    } else if (datum == null) {
      datum = DateTime.now();
      Provider.of<BiljeskeLista>(context, listen: false)
          .dodajBiljesku(uneseniNaziv, uneseniTekst, datum);
      Navigator.of(context).pop();
    } else {
      Provider.of<BiljeskeLista>(context, listen: false)
          .dodajBiljesku(uneseniNaziv, uneseniTekst, datum);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nazivController.dispose();
    _tekstSadrzajController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.library_books, size: 45, color: Colors.red),
                  SizedBox(width: 20),
                  Text(
                    'Dodaj novu bilješku',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(color: Colors.red, thickness: 1),
                ),
                SizedBox(height: 20),
                Container(
                    width: 250,
                    child: Text(
                      'Naziv',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w700),
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  width: 250,
                  height: 50,
                  child: TextField(
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 25),
                    controller: _nazivController,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      focusColor: Colors.red,
                      fillColor: Colors.red,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                    width: 250,
                    child: Text(
                      'Sadržaj',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w700),
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  width: 250,
                  child: TextField(
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none),
                      maxLines: 4,
                      controller: _tekstSadrzajController,
                      decoration: InputDecoration()),
                ),
                SizedBox(height: 10),
                Container(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          datum == null
                              ? 'Datum: '
                              : 'Datum: ${DateFormat.yMd().format(datum)}',
                              style:
                           TextStyle(
                              fontSize: 17,
                              color: Colors.red,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.date_range,
                            color: Colors.red,
                          ),
                          onPressed: _presentDatePicker)
                    ],
                  ),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  onPressed: _sacuvajBiljesku,
                  child: Text(
                    'Dodaj bilješku',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                )
              ],
            ))
      ],
    );
  }
}

class PrikazBiljeske extends StatelessWidget {
  final Biljeska biljeska;
  PrikazBiljeske({@required this.biljeska});
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.red,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              children: [
                SizedBox(width: 10),
                AutoSizeText(
                  biljeska.naziv,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  minFontSize: 27,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(color: Colors.white, thickness: 2),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    biljeska.tekstSadrzaj,
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey[200],
                        fontFamily: 'RobotoCondensed'),
                  ),
                ),
                Spacer(),
                AutoSizeText(
                  DateFormat('dd/MM/yyyy').format(biljeska.datum),
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Divider(color: Colors.white, thickness: 2),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 32,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return IzbrisiDialog(
                                  izbrisi: Provider.of<BiljeskeLista>(context,
                                          listen: false)
                                      .izbrisiBiljesku,
                                  biljeska: biljeska,
                                );
                              }).then((value) {
                            if (value == 'da') {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        child: Icon(
                          Icons.delete,
                          size: 32,
                          color: Colors.white,
                        )),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
