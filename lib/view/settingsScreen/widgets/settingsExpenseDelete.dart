import 'package:flutter/material.dart';
import 'package:expen/providers/settingsNotifier.dart';
import 'package:provider/provider.dart';

class SettingsExpenseDelete extends StatelessWidget {
  const SettingsExpenseDelete({
    Key key,
    @required this.settingsNotifier,
  }) : super(key: key);

  final SettingsNotifier settingsNotifier;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Brisanje potrošnji',
        style: TextStyle(fontSize: 22),
      ),
      subtitle: Text('Omogući brisanje potrošnji'),
      trailing: Container(
          child: Switch(
              activeColor: Colors.deepPurple,
              value: settingsNotifier.brisanjeKategorija,
              onChanged: (val) {
                Provider.of<SettingsNotifier>(context, listen: false)
                    .brisanjeKategorijaToggle();
              })),
    );
  }
}
