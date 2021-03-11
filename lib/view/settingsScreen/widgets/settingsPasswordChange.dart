import 'package:flutter/material.dart';
import 'package:expen/database/glavni_podaci_database.dart';
import 'package:expen/view/settingsScreen/widgets/addPasswordDialog.dart';
import 'package:expen/view/settingsScreen/widgets/changePasswordDialog.dart';

class SettingsPasswordChange extends StatelessWidget {
  const SettingsPasswordChange({
    Key key,
    @required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final dbData = await DatabaseHelper.fetchTable('postavke');
        final sifra = dbData[0]['sifra'];
        showDialog(
            context: context,
            builder: (ctx) {
              if (sifra == null) {
                return AddPasswordDialog();
              }
              return ChangePasswordDialog();
            }).then((value) {
          if (value == 0) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Šifra uspješno postavljena!'),
              duration: Duration(seconds: 3),
            ));
          } else if (value == 'promijenjeno') {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Šifra uspješno promijenjena!'),
              duration: Duration(seconds: 3),
            ));
          }
        });
      },
      title: Text(
        'Promijeni šifru',
        style: TextStyle(fontSize: 22),
      ),
      subtitle: Text('Promijenite staru šifru zaključavanja'),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(child: Icon(Icons.lock_open, size: 35)),
      ),
    );
  }
}
