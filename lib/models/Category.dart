import 'dart:typed_data';
import 'package:flutter/material.dart';

class Category {
  String id;
  String naziv;
  Color bojaPozadine;
  String slikaUrl;
  Map<String, double> mapaRashoda;
  bool isExpanded;
  Uint8List slikaEncoded;
  int redniBroj;
  int mjesecnoDodavanje;
  String jeLiMjesecnoDodano;

  Category({
    @required this.naziv,
    this.bojaPozadine,
    this.id,
    this.slikaUrl,
    this.mapaRashoda,
    this.isExpanded = false,
    this.slikaEncoded,
    this.redniBroj,
    this.mjesecnoDodavanje,
    this.jeLiMjesecnoDodano,
  });
}
