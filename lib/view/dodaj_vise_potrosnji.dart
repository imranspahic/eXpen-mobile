import 'package:expen/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:provider/provider.dart';
import 'package:expen/models/Subcategory.dart';

class DodajVisePotrosnji extends StatefulWidget {
  final Category kategorija;
  final Subcategory potkategorija;
  final bool uPotkategoriji;

  DodajVisePotrosnji(
      {this.kategorija, this.potkategorija, this.uPotkategoriji});

  @override
  _DodajVisePotrosnjiState createState() => _DodajVisePotrosnjiState();
}

class _DodajVisePotrosnjiState extends State<DodajVisePotrosnji> {
  final nazivController = TextEditingController();
  final brojPotrosnjiController = TextEditingController();
  final trosakController = TextEditingController();
  DateTime datum;

  @override
  void dispose() {
    nazivController.dispose();
    brojPotrosnjiController.dispose();
    trosakController.dispose();
    super.dispose();
  }

  void submitData() {
    final ExpenseNotifier expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);
    String uneseniNaziv = nazivController.text;
    final uneseniBrojPotrosnji = int.parse(brojPotrosnjiController.text);
    final uneseniTrosak = double.parse(trosakController.text);

    if (uneseniBrojPotrosnji <= 0) {
      return;
    }

    if (uneseniBrojPotrosnji >= 15) {
      showDialog(
          context: context,
          builder: (ctx) {
            return SimpleDialog(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: Column(children: <Widget>[
                      Icon(Icons.error_outline, size: 55, color: Colors.red),
                      SizedBox(height: 10),
                      Text(
                        'Previše potrošnji!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontSize: 35),
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.red, thickness: 2),
                      SizedBox(height: 5),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontSize: 25),
                              children: [
                                TextSpan(text: 'Unijeli ste prevelik broj - '),
                                TextSpan(
                                    text: '$uneseniBrojPotrosnji!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.red, fontSize: 30))
                              ])),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontSize: 25),
                              children: [
                                TextSpan(text: 'Ne možete dodati preko '),
                                TextSpan(
                                    text: '15 ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.green, fontSize: 30)),
                                TextSpan(text: 'odjednom!'),
                              ])),
                              SizedBox(height: 20),
                      Container(
                          width: 100,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.red[600],
                            child: Text('OK', style: TextStyle(color: Colors.white),)
                          ))
                    ]),
                  ),
                )
              ],
            );
         
          });
      return;
    }

    if (uneseniNaziv.isEmpty) {
      if (widget.uPotkategoriji == true) {
        uneseniNaziv = '';
      } else {
        uneseniNaziv = '';
      }
    }
    if (uneseniTrosak <= 0) {
      return;
    } else if (datum != null && widget.potkategorija == null) {
   
      expenseNotifier.dodajVisePotrosnji(widget.kategorija.naziv, uneseniNaziv, uneseniBrojPotrosnji,
          uneseniTrosak, datum, widget.kategorija.id, 'nemaPotkategorija');
    } else if (datum == null && widget.potkategorija == null) {

      datum = DateTime.now();
      expenseNotifier.dodajVisePotrosnji(widget.kategorija.naziv, uneseniNaziv, uneseniBrojPotrosnji,
          uneseniTrosak, datum, widget.kategorija.id, 'nemaPotkategorija');
    } else if (datum != null && widget.potkategorija != null) {
  
      expenseNotifier.dodajVisePotrosnji(widget.kategorija.naziv, 
          uneseniNaziv,
          uneseniBrojPotrosnji,
          uneseniTrosak,
          datum,
          widget.kategorija.id,
          widget.potkategorija.idPot);
    } else if (datum == null && widget.potkategorija != null) {
    
      datum = DateTime.now();
      expenseNotifier.dodajVisePotrosnji(widget.kategorija.naziv, 
          uneseniNaziv,
          uneseniBrojPotrosnji,
          uneseniTrosak,
          datum,
          widget.kategorija.id,
          widget.potkategorija.idPot);
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

  Widget buildTextUnose(String title, EdgeInsets padding,
      TextEditingController controller, TextInputType keyboard) {
    return Container(
      height: 110,
      padding: padding,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            keyboardType: keyboard,
            decoration: InputDecoration(
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                labelText: title,
                contentPadding: EdgeInsets.only(bottom: 10)),
            controller: controller,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj grupne potrošnje za ${widget.kategorija.naziv}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 600,
          color: Colors.orange[100],
          child: Column(children: <Widget>[
            buildTextUnose(
                'Naziv',
                EdgeInsets.only(top: 10, right: 10, left: 10),
                nazivController,
                TextInputType.text),
            buildTextUnose('Trošak', EdgeInsets.all(10), trosakController,
                TextInputType.number),
            buildTextUnose('Broj potrošnji', EdgeInsets.all(10),
                brojPotrosnjiController, TextInputType.number),
            Container(
              height: 110,
              padding: EdgeInsets.all(10),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.5),
                          ),
                        ),
                        onPressed: _presentDatePicker,
                        textColor: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 200,
              margin: EdgeInsets.only(top: 40),
              child: RaisedButton(
                child: Text(
                  'Dodaj potrošnje',
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: submitData,
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
