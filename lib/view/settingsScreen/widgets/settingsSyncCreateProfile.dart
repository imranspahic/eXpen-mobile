import 'package:expen/services/settingsServices/profileServices.dart';
import 'package:flutter/material.dart';

class SettingsSyncCreateProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        ProfileServices.createProfile(context);
      },
      title: Text(
        'Kreiraj profil',
        style: TextStyle(fontSize: 22),
      ),
      subtitle: Text('Kreiraj profil za eXpen web'),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(child: Icon(Icons.account_circle_outlined, size: 35)),
      ),
    );
  }
}
