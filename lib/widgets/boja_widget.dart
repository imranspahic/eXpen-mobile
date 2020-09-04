import 'package:flutter/material.dart';

// import '../podaci/podaci_boje.dart';


class BojaWidget extends StatelessWidget {
  final Color color;
  final String id;
  final Function dodajPotrosnju;

  
  BojaWidget(this.color, this.id, this.dodajPotrosnju);

  void uzmiBoju (String id) {
    // final boja = BOJA_DATA.firstWhere((boja) => boja.id == id);

  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => uzmiBoju(id),
        child: Container(
        width: 20,
        height: 20,
        color: color,
        
      ),
    );
  }
}