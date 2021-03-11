import 'package:flutter/material.dart';
import 'package:expen/database/glavni_podaci_database.dart';

class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  TextEditingController _sifraStaraController = TextEditingController();
  TextEditingController _sifraNovaController = TextEditingController();
  TextEditingController _sifraPonovoController = TextEditingController();
  bool error = false;
  String message;

  void sacuvaj() async {
    final _sifraStara = _sifraStaraController.text;
    final _sifraNova = _sifraNovaController.text;
    final _sifraPonovo = _sifraPonovoController.text;
    final dbData = await DatabaseHelper.fetchTable('postavke');
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
      DatabaseHelper.updateRowInTable('postavke', 'sifra', _sifraNova);
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
