import 'package:flutter/material.dart';
import 'package:expen/database/glavni_podaci_database.dart';
import 'package:expen/providers/settingsNotifier.dart';
import 'package:provider/provider.dart';
import 'package:expen/view/settingsScreen/widgets/addPasswordDialog.dart';
import 'package:expen/view/settingsScreen/widgets/confirmOldPasswordDialog.dart';

class SettingsPasswordProtection extends StatelessWidget {
  const SettingsPasswordProtection({
    Key key,
    @required this.postavkeData,
  }) : super(key: key);

  final SettingsNotifier postavkeData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      title: Text(
        ' Uključi zaštitu lozinkom',
        style: TextStyle(fontSize: 22),
      ),
      subtitle: Padding(
          padding: EdgeInsets.only(left: 5, top: 2),
          child: Text(
            'Zahtijevaj šifru svaki put kad se aplikacija pokrene',
          )),
      trailing: Container(
          child: Switch(
              activeColor: Colors.deepPurple,
              value: postavkeData.zastitaLozinkom,
              onChanged: (val) async {
                final dbData = await DatabaseHelper.fetchTabele('postavke');
                final sifra = dbData[0]['sifra'];

                if (sifra == null) {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AddPasswordDialog();
                      });
                  return;
                } else {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return ConfirmOldPasswordDialog();
                      }).then((value) {
                    if (value == 'tačno') {
                      Provider.of<SettingsNotifier>(context, listen: false)
                          .zastitaLozinkomToggle();
                    }
                  });
                }
              })),
    );
  }
}
