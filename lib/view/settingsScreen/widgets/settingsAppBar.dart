import 'package:flutter/material.dart';

AppBar settingsAppBar() {
  return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.deepPurple,
      title: Row(
        children: <Widget>[
          Icon(
            Icons.settings,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Text(
            'Postavke',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ));
}
