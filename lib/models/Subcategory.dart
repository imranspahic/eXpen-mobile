import 'package:flutter/material.dart';

class Subcategory {
  String naziv;
  String idKat;
  String idPot;
  int icon;
  Color bojaIkone;
  int mjesecnoDodavanje;
  String jeLiMjesecnoDodano;

  Subcategory(
      {this.naziv,
      this.idKat,
      this.idPot,
      this.icon,
      this.bojaIkone,
      this.mjesecnoDodavanje,
      this.jeLiMjesecnoDodano});
}