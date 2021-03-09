import 'package:flutter/material.dart';
import 'package:expen/providers/settingsNotifier.dart';
import 'package:provider/provider.dart';

class SettingsCategoryDelete extends StatelessWidget {
  const SettingsCategoryDelete({
    Key key,
    @required this.postavkeData,
  }) : super(key: key);

  final SettingsNotifier postavkeData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Brisanje kategorija',
        style: TextStyle(fontSize: 22),
      ),
      subtitle: Text('Omogući brisanje kategorija'),
      trailing: Container(
          child: Switch(
              activeColor: Colors.deepPurple,
              value: postavkeData.brisanjeKategorija,
              onChanged: (val) {
                Provider.of<SettingsNotifier>(context, listen: false)
                    .brisanjeKategorijaToggle();
              })),
    );
  }
}
