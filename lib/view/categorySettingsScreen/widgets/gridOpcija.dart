import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GridOpcija extends StatelessWidget {
  final String naziv;
  final IconData ikona;
  final Image slika;
  final Function funkcija;
  GridOpcija({this.naziv, this.ikona, this.slika, this.funkcija});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: funkcija,
          child: Container(
        
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(20)
        ),
        height: 50,
        width: 50,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              slika == null
                  ? Icon(
                      ikona,
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    )
                  : Container(
                      child: slika,
                      width: 50,
                      height: 50,
                    ),
              Container(
                child: AutoSizeText(
                  naziv,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  minFontSize: 15,
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                ),
              )
            ]),
      ),
    );
  }
}
