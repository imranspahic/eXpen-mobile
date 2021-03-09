import 'package:expen/utils/fieldDivider.dart';
import 'package:flutter/material.dart';

class SettingsProfileInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          FieldDivider(
            isHorizontal: true,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Imran Spahić'),
              Text('Email: imranspahic300@gmail.com'),
              Text('Kreiran: 9.3.2021')
            ],
          )
        ],
      ),
    );
  }
}
