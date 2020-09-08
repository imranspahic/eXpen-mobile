import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/biljeske_provider.dart';
import 'model/obavijesti_provider.dart';
import 'model/data_provider.dart';
import 'model/plata_provider.dart';
import 'model/rashod_kategorija_provider.dart';
import './ekrani/sifra_ekran.dart';

void main()  {
  runApp(MyApp());
}
 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => KategorijaLista(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PotrosnjaLista(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PotKategorijaLista(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SveKategorije(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BiljeskeLista(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ObavijestiLista(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PlataLista(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RashodKategorijaLista(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'eXpen',
        theme: ThemeData(
            primarySwatch: Colors.orange,
            accentColor: Colors.brown,
           

            textTheme: ThemeData.light().textTheme.copyWith(
                headline2: TextStyle( 
                    fontSize: 45,
                    fontFamily: 'Raleway',
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6),
                headline6: TextStyle(fontSize: 30, fontFamily: 'RobotoCondensed'),
                subtitle2: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Raleway',
                  color: Colors.orangeAccent[100],
                ),
                
                caption: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Lato',
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0),
                subtitle1: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Raleway',
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0),
                button: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Raleway',
                    color: Colors.brown[900],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0),
                headline5: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Raleway',
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0))),
        routes: {
          '/': (ctx) => SifraEkran(),
        },
      ),
    );
  }
}
