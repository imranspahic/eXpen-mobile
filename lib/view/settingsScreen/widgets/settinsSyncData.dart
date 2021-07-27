import 'package:expen/services/settingsServices/dataSyncServices.dart';
import 'package:flutter/material.dart';

class SettingsSyncData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        DataSyncService().uploadDataToServer(context);
      },
      title: Text(
        'Sinkroniziraj podatke',
        style: TextStyle(fontSize: 22),
      ),
      subtitle: Text('Upload podatke na eXpen server'),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(child: Icon(Icons.account_circle_outlined, size: 35)),
      ),
    );
  }
}
