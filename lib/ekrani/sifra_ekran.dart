import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semir_potrosnja/database/kategorija_database.dart';
import '../model/data_provider.dart';
import './pocetni_ekran.dart';

class SifraEkran extends StatefulWidget {
  @override
  _SifraEkranState createState() => _SifraEkranState();
}

class _SifraEkranState extends State<SifraEkran> {
  Future sifraFuture;

  @override
  void initState() {
    
    sifraFuture = Provider.of<SveKategorije>(context, listen: false)
        .fetchAndSetPostavke();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: sifraFuture,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (Provider.of<SveKategorije>(context).zastitaLozinkom) {
                  return Zastita();
                } else {
                  return PocetniEkran();
                }
              }
            }));
  }
}

class Zastita extends StatefulWidget {
  @override
  _ZastitaState createState() => _ZastitaState();
}

class _ZastitaState extends State<Zastita> {
  TextEditingController _sifraController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool error = false;

  void otkljucaj() async {
    final _sifra = _sifraController.text;
    final dbData = await DatabaseHelper.fetchTabele('postavke');
    final sifra = dbData[0]['sifra'];

    if (_sifra != sifra) {
      setState(() {
        error = true;
      });
      return;
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
        return PocetniEkran();
      }));
    }
  }

  @override
  void dispose() {
    _sifraController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 70,
                    height: 70,
                    child: Image.asset(
                      'assets/images/logo_coin.png',
                      fit: BoxFit.cover,
                    )),
                SizedBox(width: 10),
                FittedBox(
                  child: RichText(
                      text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(fontSize: 90),
                          children: [
                        TextSpan(text: 'e'),
                        TextSpan(
                          text: 'X',
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 90,
                              color: Colors.yellow[600],
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(text: 'pen'),
                      ])),
                ),
              ],
            ),
            Icon(
              Icons.lock,
              size: 200,
              color: Colors.red,
            ),
            Container(
              width: 200,
              child: TextField(
                onTap: () {
                  setState(() {
                    error = false;
                  });
                },
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Unesite šifru!',
                  hintStyle: TextStyle(color: Colors.yellow[700]),
                ),
                textAlign: TextAlign.center,
                obscureText: true,
                controller: _sifraController,
              ),
            ),
            SizedBox(height: 10),
            if (error)
              Column(children: <Widget>[
                Icon(Icons.error, size: 35, color: Colors.red),
                SizedBox(height: 5),
                Text(
                  'Netačna šifra!',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                )
              ]),
            SizedBox(height: 10),
            Container(
              width: 140,
              child: RaisedButton(
                  onPressed: otkljucaj,
                  color: Colors.orange,
                  child: Text(
                    'Otključaj',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
