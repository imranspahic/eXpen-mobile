import 'package:flutter/material.dart';
import 'package:expen/database/glavni_podaci_database.dart';
import 'package:expen/providers/settingsNotifier.dart';
import 'package:provider/provider.dart';

class AddPasswordDialog extends StatefulWidget {
  @override
  _AddPasswordDialogState createState() => _AddPasswordDialogState();
}

class _AddPasswordDialogState extends State<AddPasswordDialog> {
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
      Provider.of<SettingsNotifier>(context, listen: false)
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
