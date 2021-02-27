import 'package:flutter/material.dart';
import 'package:semir_potrosnja/database/glavni_podaci_database.dart';

class ConfirmOldPasswordDialog extends StatefulWidget {
  @override
  _ConfirmOldPasswordDialogState createState() =>
      _ConfirmOldPasswordDialogState();
}

class _ConfirmOldPasswordDialogState extends State<ConfirmOldPasswordDialog> {
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
