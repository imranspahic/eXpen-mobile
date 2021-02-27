import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  final String naziv;
  final IconData ikona;

  SettingsHeader(this.naziv, this.ikona);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, top: 15, bottom: 0, right: 15.0),
      child: Row(children: <Widget>[
        Icon(
          ikona,
          color: Colors.grey,
        ),
        SizedBox(width: 10),
        Text(
          naziv,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.grey[600]),
        )
      ]),
    );
  }
}
