import 'package:flutter/material.dart';

class DrawerSectionHeadline extends StatelessWidget {
  final String headlineText;
  final IconData headlineIcon;
  const DrawerSectionHeadline(
      {@required this.headlineText, @required this.headlineIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        child: Container(
            padding: EdgeInsets.all(6),
            child: Row(
              children: <Widget>[
                Icon(headlineIcon, size: 25),
                SizedBox(width: 10),
                Text(
                  headlineText,
                  style: TextStyle(fontSize: 25, fontFamily: 'Raleway'),
                ),
              ],
            )));
  }
}
