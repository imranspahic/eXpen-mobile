import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/data_provider.dart';

class DodajNovuKategoriju extends StatefulWidget {
 // statefull zbog konteksta koji se dobija u funkcijama submit data ...



  @override
  _DodajNovuKategorijuState createState() => _DodajNovuKategorijuState();
}

class _DodajNovuKategorijuState extends State<DodajNovuKategoriju> {
  final nazivController = TextEditingController();


  void submitData() {
    final uneseniNaziv = nazivController.text; 
    
    if (uneseniNaziv.isEmpty || uneseniNaziv.length > 25) {
      Navigator.of(context).pop('error');
      return;
      
      
    }

    final katData = Provider.of<KategorijaLista>(context, listen: false);
     int redniBroj;
     print( 'broj kategorija: ${katData.kategorijaLista.length}');
    redniBroj = katData.kategorijaLista.length +1;
    katData.dodajKategoriju(uneseniNaziv, redniBroj);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
          margin: EdgeInsets.only(top: 20),
          height: 50,
          width: 250,
          child: RaisedButton(
            
            child: Text('Dodaj kategoriju', style: Theme.of(context).textTheme.button,),
            onPressed: submitData,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
