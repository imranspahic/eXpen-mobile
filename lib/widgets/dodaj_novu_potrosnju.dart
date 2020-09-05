import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/data_provider.dart';
import '../database/kategorija_database.dart';

class DodajNovuPotrosnju extends StatefulWidget {
  final KategorijaModel kategorija;
  final PotKategorija potkategorija;
  final bool uPotkategoriji;
  final bool jeLiPlaniranaPotrosnja;
  DodajNovuPotrosnju(
      {this.kategorija, this.potkategorija, this.uPotkategoriji, this.jeLiPlaniranaPotrosnja});
  @override
  _DodajNovuPotrosnjuState createState() => _DodajNovuPotrosnjuState();
}

class _DodajNovuPotrosnjuState extends State<DodajNovuPotrosnju> {
  final nazivController = TextEditingController();
  final trosakController = TextEditingController();
  DateTime datum;

  @override
  void dispose() {
    nazivController.dispose();
    trosakController.dispose();
    super.dispose();
  }

  void submitData() {
    final potrosnjaData = Provider.of<PotrosnjaLista>(context, listen: false);
    String uneseniNaziv = nazivController.text;
    final uneseniTrosak = double.parse(trosakController.text);

    if (uneseniNaziv.isEmpty) {
      if (widget.uPotkategoriji == true) {
        uneseniNaziv = '';
      } else {
        uneseniNaziv ='';
      }
    }
    if (uneseniTrosak <= 0) {
      return;
    }
    else if(widget.jeLiPlaniranaPotrosnja) {
      potrosnjaData.dodajPlaniranuPotrosnju(widget.kategorija.naziv, uneseniNaziv, uneseniTrosak, widget.kategorija.id, 'nemaPotkategorija');
      
    }
     else if (datum != null && widget.potkategorija == null) {
      potrosnjaData.dodajPotrosnju(widget.kategorija.naziv, uneseniNaziv, uneseniTrosak, datum,
          widget.kategorija.id, 'nemaPotkategorija');
    } else if (datum == null && widget.potkategorija == null) {
      datum = DateTime.now();
      potrosnjaData.dodajPotrosnju(widget.kategorija.naziv, uneseniNaziv, uneseniTrosak, datum,
          widget.kategorija.id, 'nemaPotkategorija');
    } else if (datum != null && widget.potkategorija != null) {
      potrosnjaData.dodajPotrosnju(widget.kategorija.naziv, uneseniNaziv, uneseniTrosak, datum,
          widget.kategorija.id, widget.potkategorija.idPot);
    } else if (datum == null && widget.potkategorija != null) {
      datum = DateTime.now();
      potrosnjaData.dodajPotrosnju(widget.kategorija.naziv, uneseniNaziv, uneseniTrosak, datum,
          widget.kategorija.id, widget.potkategorija.idPot);
    }

    Navigator.of(context).pop([datum]);
  }

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

  Widget buildtextPolja(String title, EdgeInsets margin, TextEditingController controller, TextInputType keyboard) {
    return Container(
          margin: margin,
          padding: EdgeInsets.all(10),
          child: TextField(
            keyboardType: keyboard,
            style: TextStyle(
              fontSize: 35,
              color: Theme.of(context).accentColor,
              letterSpacing: 1,
            ),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                labelText: title,
                labelStyle: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor)),
            controller: controller,
          ),
        );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildtextPolja('Naziv', EdgeInsets.only(top: 40, left: 15, right: 15), nazivController, TextInputType.text),
        buildtextPolja('Trošak', EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 20), trosakController, TextInputType.number),
        if(!widget.jeLiPlaniranaPotrosnja) Container(
          height: 70,
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    datum == null
                        ? 'Datum: '
                        : 'Datum: ${DateFormat.yMd().format(datum)}',
                    style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                FlatButton(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      'Izaberi datum',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  onPressed: _presentDatePicker,
                  textColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ),
        Container(
          height: 50,
          width: 200,
          margin: EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text(
              'Dodaj potrošnju',
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: submitData,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
