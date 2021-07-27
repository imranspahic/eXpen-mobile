import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';

class DodajNovuPotKategoriju extends StatefulWidget {
  final CategoryModel kategorija;
  DodajNovuPotKategoriju(this.kategorija);

  @override
  _DodajNovuPotKategorijuState createState() => _DodajNovuPotKategorijuState();
}

class _DodajNovuPotKategorijuState extends State<DodajNovuPotKategoriju> {
  final nazivController = TextEditingController();

  @override
  void dispose() {
    nazivController.dispose();
    super.dispose();
  }

  void submitData() {
    final uneseniNaziv = nazivController.text;

    if (uneseniNaziv.isEmpty) {
      return;
    }

    final SubcategoryNotifier subcategoryNotifier = Provider.of<SubcategoryNotifier>(context, listen: false);
    subcategoryNotifier.dodajPotKategoriju(
      uneseniNaziv,
      widget.kategorija.id,
    );
    Navigator.of(context).pop(uneseniNaziv);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          padding: EdgeInsets.all(10),
          child: TextField(
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).accentColor,
              letterSpacing: 1,
            ),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                labelText: 'Naziv',
                labelStyle: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor)),
            controller: nazivController,
            // onSubmitted: (_) => submitData(),
          ),
        ),
        Container(
          height: 50,
          width: 250,
          child: RaisedButton(
            child: Text(
              'Dodaj potkategoriju',
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
