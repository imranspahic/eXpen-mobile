import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/settingsNotifier.dart';

class SettingsExpenseView extends StatelessWidget {
  const SettingsExpenseView({
    Key key,
    @required this.postavkeData,
  }) : super(key: key);

  final SettingsNotifier postavkeData;

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
              value: postavkeData.vertikalniPrikaz,
              onChanged: (val) {
                Provider.of<SettingsNotifier>(context, listen: false)
                    .vertikalniPrikazToggle();
              })),
    );
  }
}
