import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

import '../model/data_provider.dart';
import '../database/kategorija_database.dart';
import '../widgets/pdf_dialog.dart';
import '../widgets/pdf_builder.dart';

class PostavkeEkran extends StatefulWidget {
  @override
  _PostavkeEkranState createState() => _PostavkeEkranState();
}

class _PostavkeEkranState extends State<PostavkeEkran> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    final postData = Provider.of<SveKategorije>(context, listen: false);
    postData.fetchAndSetPostavke();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postavkeData = Provider.of<SveKategorije>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.deepPurple,
          title: Row(
            children: <Widget>[
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'Postavke',
                style: TextStyle(color: Colors.white),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: <Widget>[
              KategorijaPostavki('Prikaz', Icons.view_carousel),
              ListTile(
                title: Text(
                  'Prikaz potrošnji',
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Text('Prikaži potrošnje jednu ispod druge'),
                trailing: Container(
                    child: Switch(
                        activeColor: Colors.deepPurple,
                        value: postavkeData.vertikalniPrikaz,
                        onChanged: (val) {
                          Provider.of<SveKategorije>(context, listen: false)
                              .vertikalniPrikazToggle();
                        })),
              ),
              ListTile(
                title: Text(
                  'Brisanje kategorija',
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Text('Omogući brisanje kategorija'),
                trailing: Container(
                    child: Switch(
                        activeColor: Colors.deepPurple,
                        value: postavkeData.brisanjeKategorija,
                        onChanged: (val) {
                          Provider.of<SveKategorije>(context, listen: false)
                              .brisanjeKategorijaToggle();
                        })),
              ),
              KategorijaPostavki('Sigurnost', Icons.lock),
              ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Text(
                  ' Uključi zaštitu lozinkom',
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Padding(
                    padding: EdgeInsets.only(left: 5, top: 2),
                    child: Text(
                      'Zahtijevaj šifru svaki put kad se aplikacija pokrene',
                    )),
                trailing: Container(
                    child: Switch(
                        activeColor: Colors.deepPurple,
                        value: postavkeData.zastitaLozinkom,
                        onChanged: (val) async {
                          final dbData =
                              await DatabaseHelper.fetchTabele('postavke');
                          final sifra = dbData[0]['sifra'];

                          if (sifra == null) {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return DodajSifru();
                                });
                            return;
                          } else {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return KucajStaruSifru();
                                }).then((value) {
                              if (value == 'tačno') {
                                Provider.of<SveKategorije>(context,
                                        listen: false)
                                    .zastitaLozinkomToggle();
                              }
                            });
                          }
                        })),
              ),
              ListTile(
                onTap: () async {
                  final dbData = await DatabaseHelper.fetchTabele('postavke');
                  final sifra = dbData[0]['sifra'];
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        if (sifra == null) {
                          return DodajSifru();
                        }
                        return PromjenaSifre();
                      }).then((value) {
                    if (value == 0) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Šifra uspješno postavljena!'),
                        duration: Duration(seconds: 3),
                      ));
                    } else if (value == 'promijenjeno') {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Šifra uspješno promijenjena!'),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  });
                },
                title: Text(
                  'Promijeni šifru',
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Text('Promijenite staru šifru zaključavanja'),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(child: Icon(Icons.lock_open, size: 35)),
                ),
              ),
              KategorijaPostavki('Podaci', Icons.note),
              ListTile(
                onTap: () async {
                  final kategorijaData =
                      Provider.of<KategorijaLista>(context, listen: false);
                  final providerData =
                      Provider.of<PotrosnjaLista>(context, listen: false);
                  final potkategorijaData =
                      Provider.of<PotKategorijaLista>(context, listen: false);

                  List<PotrosnjaModel> data = providerData.listaSvihPotrosnji;
                  data.forEach((potrosnja) {
                    if(potrosnja.naziv.contains('š')){potrosnja.naziv = potrosnja.naziv.replaceFirst(RegExp('š'), 's');}
                    if(potrosnja.naziv.contains('č')){potrosnja.naziv = potrosnja.naziv.replaceFirst(RegExp('č'), 'c');}
                    if(potrosnja.naziv.contains('ć')){potrosnja.naziv = potrosnja.naziv.replaceFirst(RegExp('ć'), 'c');}
                    if(potrosnja.naziv.contains('ž')){potrosnja.naziv = potrosnja.naziv.replaceFirst(RegExp('ž'), 'z');}
                  
                  });
                  List<List<dynamic>> csvData = [
                    <String>[
                      'Naziv',
                      'Trosak',
                      'Datum',
                      'Kategorija',
                      'Potkategorija'
                    ],
                    ...data.map((item) => [
                          ' ${item.naziv}',
                          '  ${item.trosak.toStringAsFixed(2)} KM',
                          '  ${DateFormat.yMMMMd().format(item.datum)}',
                          '${kategorijaData.dobijKategorijuPoId(item.idKategorije).naziv}',
                          '${potkategorijaData.potKategorijaPoId(item.idPotKategorije)}',
                        ])
                  ];
                  String csv = const ListToCsvConverter().convert(csvData);

                  final String dir = '/storage/emulated/0/Download';

                  final String path = '$dir/eXpen-potrosnje.csv';
                  final File file = File(path);
                  var status = await Permission.storage.status;
                  if (!status.isGranted) {
                    await Permission.storage.request();
                  }
                  await file.writeAsString(csv);

                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return IzveziPotrosnje();
                      });
                },
                title: Text(
                  'Izvezi potrošnje',
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Text('Kreiraj .csv fajl sa potrošnjama'),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                      width: 40,
                      child: Image.asset('assets/images/excel-logo.png',
                          fit: BoxFit.cover)),
                ),
              ),
              ListTile(
                onTap: () async {
                  var status = await Permission.storage.status;
                  if (!status.isGranted) {
                    await Permission.storage.request();
                  }
                  final pdfBuilder = PdfBuilderFunc();

                  await pdfBuilder.buildPdf(context, true);
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return PreuzmiPDF(
                          nazivDokumenta: 'eXpen-podaci',
                        );
                      });
                },
                title: Text(
                  'Izvezi u pdf',
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Text('Kreiraj .pdf fajl sa svim podacima'),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                      width: 40,
                      child: Image.asset('assets/images/pdf-logo.png',
                          fit: BoxFit.cover)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KategorijaPostavki extends StatelessWidget {
  final String naziv;
  final IconData ikona;

  KategorijaPostavki(this.naziv, this.ikona);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, top: 15, bottom: 0, right: 15.0),
      child: Row(children: <Widget>[
        Icon(
          ikona,
          color: Colors.grey,
        ),
        SizedBox(width: 10),
        Text(
          naziv,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.grey[600]),
        )
      ]),
    );
  }
}

class DodajSifru extends StatefulWidget {
  @override
  _DodajSifruState createState() => _DodajSifruState();
}

class _DodajSifruState extends State<DodajSifru> {
  TextEditingController _sifraController = TextEditingController();
  TextEditingController _sifraPonovoController = TextEditingController();
  bool error = false;
  String message;

  void postaviSifru() {
    final sifra = _sifraController.text;
    final ponovoSifra = _sifraPonovoController.text;
    if (sifra != ponovoSifra) {
      setState(() {
        error = true;
        message = 'Šifre se ne podudaraju!';
      });
      return;
    } else if (sifra == null || sifra == '' || sifra.length < 5) {
      setState(() {
        error = true;
        message = 'Šifra ne smije biti kraća od 5 znakova!';
      });
      return;
    } else {
      setState(() {
        error = false;
      });
      DatabaseHelper.updateSifru('postavke', 'sifra', '$sifra');
      Provider.of<SveKategorije>(context, listen: false)
          .zastitaLozinkomToggle();
      Navigator.of(context).pop(0);
    }
  }

  @override
  void dispose() {
    _sifraController.dispose();
    _sifraPonovoController.dispose();
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
                Icon(Icons.warning, size: 65, color: Colors.red),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 40),
                  child: Text(
                    'Niste još postavili šifru da biste uključili ovu opciju!',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 200,
                  child: TextField(
                    controller: _sifraController,
                    decoration: InputDecoration(
                        labelText: 'Unesite novu šifru',
                        labelStyle: TextStyle(fontSize: 20)),
                    obscureText: true,
                  ),
                ),
                Container(
                  width: 200,
                  child: TextField(
                    controller: _sifraPonovoController,
                    decoration: InputDecoration(
                        labelText: 'Potvrdite šifru',
                        labelStyle: TextStyle(fontSize: 20)),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20),
                if (error)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                RaisedButton(
                  onPressed: postaviSifru,
                  child: Text(
                    'Postavi šifru',
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

class PromjenaSifre extends StatefulWidget {
  @override
  _PromjenaSifreState createState() => _PromjenaSifreState();
}

class _PromjenaSifreState extends State<PromjenaSifre> {
  TextEditingController _sifraStaraController = TextEditingController();
  TextEditingController _sifraNovaController = TextEditingController();
  TextEditingController _sifraPonovoController = TextEditingController();
  bool error = false;
  String message;

  void sacuvaj() async {
    final _sifraStara = _sifraStaraController.text;
    final _sifraNova = _sifraNovaController.text;
    final _sifraPonovo = _sifraPonovoController.text;
    final dbData = await DatabaseHelper.fetchTabele('postavke');
    final sifra = dbData[0]['sifra'];

    if (_sifraStara != sifra) {
      setState(() {
        error = true;
        message = 'Netačna stara šifra!';
      });
      return;
    } else if (_sifraNova != _sifraPonovo) {
      setState(() {
        error = true;
        message = 'Nove šifre se ne podudaraju!';
      });
    } else if (_sifraNova == null ||
        _sifraNova == '' ||
        _sifraNova.length < 5) {
      setState(() {
        error = true;
        message = 'Šifra ne smije biti kraća od 5 znakova!';
      });
      return;
    } else {
      DatabaseHelper.updateSifru('postavke', 'sifra', _sifraNova);
      Navigator.of(context).pop('promijenjeno');
    }
  }

  @override
  void dispose() {
    _sifraStaraController.dispose();
    _sifraNovaController.dispose();
    _sifraPonovoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.lock_open, color: Colors.grey, size: 40),
                    SizedBox(width: 10),
                    Container(
                        width: 200,
                        child: TextField(
                          decoration: InputDecoration(
                              labelText: 'Unesi staru šifru!',
                              labelStyle: TextStyle(fontSize: 20)),
                          controller: _sifraStaraController,
                          obscureText: true,
                        )),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.lock, color: Colors.grey, size: 40),
                    SizedBox(width: 10),
                    Container(
                        width: 200,
                        child: TextField(
                          decoration: InputDecoration(
                              labelText: 'Unesi novu šifru!',
                              labelStyle: TextStyle(fontSize: 20)),
                          controller: _sifraNovaController,
                          obscureText: true,
                        )),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.lock, color: Colors.grey, size: 40),
                    SizedBox(width: 10),
                    Container(
                        width: 200,
                        child: TextField(
                          decoration: InputDecoration(
                              labelText: 'Potvrdi novu šifru!',
                              labelStyle: TextStyle(fontSize: 20)),
                          controller: _sifraPonovoController,
                          obscureText: true,
                        )),
                  ]),
              SizedBox(height: 20),
              if (error)
                Text(
                  message,
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              SizedBox(height: 15),
              Container(
                width: 200,
                child: RaisedButton(
                  onPressed: sacuvaj,
                  child: Text(
                    'Sačuvaj',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class IzveziPotrosnje extends StatefulWidget {
  @override
  _IzveziPotrosnjeState createState() => _IzveziPotrosnjeState();
}

class _IzveziPotrosnjeState extends State<IzveziPotrosnje> {
  Future<void> _loadingFuture() {
    return Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.55,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: Theme.of(context).textTheme.headline6,
                        children: [
                          TextSpan(text: 'Izrađujem '),
                          TextSpan(
                              text: 'excel',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Colors.green[600],
                                      fontWeight: FontWeight.bold)),
                          TextSpan(text: '/'),
                          TextSpan(
                              text: 'csv ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold)),
                          TextSpan(text: 'dokument!'),
                        ])),
                SizedBox(height: 10),
                Container(
                    width: 70,
                    height: 70,
                    child: Image.asset('assets/images/excel-logo.png')),
                SizedBox(height: 30),
                FutureBuilder(
                    future: _loadingFuture(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.headline5,
                                  children: [
                                    TextSpan(text: 'Dokument '),
                                    TextSpan(
                                      text: 'eXpen-potrosnje.csv ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[600]),
                                    ),
                                    TextSpan(text: 'kreiran!'),
                                  ]),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.headline5,
                                  children: [
                                    TextSpan(text: 'Direktorij: '),
                                    TextSpan(
                                      text: '/storage/emulated/0/Download ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600]),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    width: 100,
                                    child: RaisedButton(
                                      color: Colors.green[700],
                                      onPressed: () {
                                        String path =
                                            '/storage/emulated/0/Download/eXpen-potrosnje.csv';

                                        OpenFile.open(path);
                                      },
                                      child: Text(
                                        'Otvori',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                                Container(
                                    width: 100,
                                    child: RaisedButton(
                                      color: Colors.green[700],
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Izađi',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ],
                            )
                          ],
                        );
                      }
                    })
              ],
            ),
          ),
        )
      ],
    );
  }
}

class KucajStaruSifru extends StatefulWidget {
  @override
  _KucajStaruSifruState createState() => _KucajStaruSifruState();
}

class _KucajStaruSifruState extends State<KucajStaruSifru> {
  TextEditingController _sifraController = TextEditingController();

  bool error = false;
  String message;

  void sacuvaj() async {
    final sifraUkucana = _sifraController.text;
    final dbData = await DatabaseHelper.fetchTabele('postavke');
    final sifra = dbData[0]['sifra'];

    if (sifraUkucana != sifra) {
      setState(() {
        error = true;
        message = 'Netačna šifra!';
      });
      return;
    } else {
      Navigator.of(context).pop('tačno');
    }
  }

  @override
  void dispose() {
    _sifraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.lock_open, color: Colors.grey, size: 40),
                    SizedBox(width: 10),
                    Container(
                        width: 200,
                        child: TextField(
                          decoration: InputDecoration(
                              labelText: 'Unesi šifru!',
                              labelStyle: TextStyle(fontSize: 20)),
                          controller: _sifraController,
                          obscureText: true,
                        )),
                  ]),
              SizedBox(height: 20),
              if (error)
                Text(
                  message,
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              SizedBox(height: 15),
              Container(
                width: 200,
                child: RaisedButton(
                  onPressed: sacuvaj,
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
