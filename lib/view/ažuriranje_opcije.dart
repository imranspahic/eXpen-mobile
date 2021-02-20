import 'package:flutter/material.dart';
import 'package:semir_potrosnja/database/glavni_podaci_database.dart';
import '../database/rashod_plata_database.dart' as rpDB;

class AzuriranjeOpcije extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[300],
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.grey[700],), onPressed: () {Navigator.of(context).pop();}),
        title: Row(children: <Widget>[
          Icon(
            Icons.more,
            color: Colors.grey[700],
          ),
          SizedBox(width: 10),
          Text(
            'Ažuriranje',
            style: TextStyle(color: Colors.grey[700]),
          )
        ]),
      ),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:5.0, vertical: 15.0),
        child: Column(
          children: <Widget> [
             ListTile(
                  onTap: () async{
                    DatabaseHelper.updateSlikePathFix('kategorije', 'assets/images/nema-slike.jpg');
                  },
                  title: Text(
                    'Verzija 1.0.1.',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: Text('Popravak u bazi podataka'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(child: Icon(Icons.perm_data_setting , size: 35)),
                  ),
                ),
            ListTile(
                  onTap: () async{
                    DatabaseHelper.addDBColumnFix('kategorije');
                  },
                  title: Text(
                    'Verzija 1.0.2.',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: Text('Popravak u bazi podataka, redni broj kategorija'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(child: Icon(Icons.perm_data_setting , size: 35)),
                  ),
                ),
            ListTile(
                  onTap: () async{
                    DatabaseHelper.dodajTabeluBiljeske();
                  },
                  title: Text(
                    'Verzija 1.0.3.',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: Text('Dodaj bilješke'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(child: Icon(Icons.perm_data_setting , size: 35)),
                  ),
                ),
             ListTile(
                  onTap: () async{
                    DatabaseHelper.dodajTabeluPlaniranePotrosnje();
                  },
                  title: Text(
                    'Verzija 1.0.4.',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: Text('Dodaj planirane potrošnje tabelu!'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(child: Icon(Icons.perm_data_setting , size: 35)),
                  ),
                ),
            ListTile(
                  onTap: () async{
                    DatabaseHelper.dodajColumnMjesecnoDodavanje('kategorije');
                  },
                  title: Text(
                    'Verzija 1.0.5.',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: Text('Dodaj mjesečno dodavanje u kategorije tabelu!'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(child: Icon(Icons.perm_data_setting , size: 35)),
                  ),
                ),
            ListTile(
                  onTap: () async{
                    DatabaseHelper.dodajTabeluObavijesti();
                  },
                  title: Text(
                    'Verzija 1.0.6.',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: Text('Dodaj tabelu obavijesti u bazu!'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(child: Icon(Icons.perm_data_setting , size: 35)),
                  ),
                ),
            ListTile(
                  onTap: () async{
                    DatabaseHelper.dodajColumnMjesecnoDodavanjePotkategorije('potkategorije');
                  },
                  title: Text(
                    'Verzija 1.0.7.',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: Text('Dodaj tabelu mjesečno dodavanje u potkategorije tabelu!'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(child: Icon(Icons.perm_data_setting , size: 35)),
                  ),
                ),
            ListTile(
                  onTap: () async{
                    rpDB.DatabaseHelper.dodajRashodKategorijaTabelu();
                  },
                  title: Text(
                    'Verzija 1.0.8.',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: Text('Dodaj tabelu rashod kategorija'),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(child: Icon(Icons.perm_data_setting , size: 35)),
                  ),
                ),
          ]
          
        ),
      ),),
      
    );
  }
}