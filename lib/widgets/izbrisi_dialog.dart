import 'package:flutter/material.dart';
import '../model/biljeske_provider.dart';
import '../model/data_provider.dart';

class IzbrisiDialog extends StatelessWidget {
  final Function izbrisi;
  final Biljeska biljeska;
  final PotrosnjaModel potrosnja;
  IzbrisiDialog({this.izbrisi, this.biljeska, this.potrosnja});
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      children: [
        Container(
          width: 50,
          height: 200,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Izbrisati?',
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Lato',
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  InkWell(
                    child: Icon(Icons.check, size: 80, color: Colors.orange[100]),
                    onTap: () {
                      izbrisi(biljeska != null ? biljeska.id : potrosnja.id);
                      Navigator.of(context).pop('da');
                    },
                  ),
                  SizedBox(width: 30),
                  InkWell(
                    child: Icon(
                      Icons.cancel,
                      size: 80,
                      color: Colors.orange[100],
                    ),
                    onTap: () {
                      Navigator.of(context).pop('ne');
                    },
                  )
                ])
              ],
            ),
          ),
        )
      ],
    );
  }
}
