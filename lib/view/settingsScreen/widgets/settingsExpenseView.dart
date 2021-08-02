import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/settingsNotifier.dart';

class SettingsExpenseView extends StatelessWidget {
  const SettingsExpenseView({
    Key key,
    @required this.settingsNotifier,
  }) : super(key: key);

  final SettingsNotifier  settingsNotifier;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Prikaz potrošnji',
        style: TextStyle(fontSize: 22),
      ),
      subtitle: Text('Prikaži potrošnje jednu ispod druge'),
      trailing: Container(
          child: Switch(
              activeColor: Colors.deepPurple,
              value: settingsNotifier.vertikalniPrikaz,
              onChanged: (val) {
                Provider.of<SettingsNotifier>(context, listen: false)
                    .vertikalniPrikazToggle();
              })),
    );
  }
}
