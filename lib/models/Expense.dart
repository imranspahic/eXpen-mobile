import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Expense {
  String id;
  String naziv;
  double trosak;
  DateTime datum;
  String nazivKategorije;
  String idKategorije;
  String idPotKategorije;

  String getIndex(int row, int i) {
    switch (i) {
      case 0:
        return (row + 1).toString();
        break;
      case 1:
        return this.naziv;
        break;
      case 2:
        return this.trosak.toString();
        break;
      case 3:
        return DateFormat('dd. MM. yyyy.').format(this.datum);
        break;
      case 4:
        return this.nazivKategorije;
        break;
      default:
        return '';
    }
  }

  Expense(
      {@required this.id,
      @required this.naziv,
      @required this.trosak,
      this.datum,
      this.nazivKategorije,
      this.idKategorije,
      this.idPotKategorije});
}
