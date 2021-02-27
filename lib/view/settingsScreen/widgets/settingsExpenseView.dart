import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semir_potrosnja/model/data_provider.dart';

class SettingsExpenseView extends StatelessWidget {
  const SettingsExpenseView({
    Key key,
    @required this.postavkeData,
  }) : super(key: key);

  final SveKategorije postavkeData;

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
                Provider.of<SveKategorije>(context, listen: false)
                    .vertikalniPrikazToggle();
              })),
    );
  }
}
