import 'package:expen/providers/profileNotifier.dart';
import 'package:expen/view/settingsScreen/widgets/settingsProfileInformation.dart';
import 'package:expen/view/settingsScreen/widgets/settingsSyncCreateProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/settingsNotifier.dart';
import 'package:expen/view/settingsScreen/widgets/settingsAppBar.dart';
import 'package:expen/view/settingsScreen/widgets/settingsCategoryDelete.dart';
import 'package:expen/view/settingsScreen/widgets/settingsExcelExport.dart';
import 'package:expen/view/settingsScreen/widgets/settingsExpenseDelete.dart';
import 'package:expen/view/settingsScreen/widgets/settingsExpenseView.dart';
import 'package:expen/view/settingsScreen/widgets/settingsHeader.dart';
import 'package:expen/view/settingsScreen/widgets/settingsPasswordChange.dart';
import 'package:expen/view/settingsScreen/widgets/settingsPasswordProtection.dart';
import 'package:expen/view/settingsScreen/widgets/settingsPdfExport.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    final postData = Provider.of<SettingsNotifier>(context, listen: false);
    postData.fetchAndSetPostavke();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postavkeData = Provider.of<SettingsNotifier>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: settingsAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: <Widget>[
              SettingsHeader('Prikaz', Icons.view_carousel),
              SettingsExpenseView(postavkeData: postavkeData),
              SettingsCategoryDelete(postavkeData: postavkeData),
              SettingsExpenseDelete(postavkeData: postavkeData),
              SettingsHeader('Sigurnost', Icons.lock),
              SettingsPasswordProtection(postavkeData: postavkeData),
              SettingsPasswordChange(scaffoldKey: _scaffoldKey),
              SettingsHeader('Podaci', Icons.note),
              SettingsExcelExport(),
              SettingsPDFExport(),
              SettingsHeader('Sinkronizacija', Icons.sync),
              Consumer<ProfileNotifier>(
                builder: (ctx, provider, child) {
                  return provider.hasProfile
                      ? SettingsProfileInformation()
                      : SettingsSyncCreateProfile();
                },
              ),
              // ListTile(
              //   title: Text('Lista proizvoda'),
              //   subtitle: Text('Dobij listu proizvoda sa servera'),
              //   onTap: () async {
              //     try {
              //       const url = "http://192.168.1.7:3000/api/products";
              //       final http.Response body = await http.get(url);
              //       print(body.body);
              //     } catch (e) {
              //       print("Error - $e");
              //     }
              //   },
              // ),
              // ListTile(
              //   title: Text('Kreiraj korisnika'),
              //   subtitle: Text('Kreiraj korisnika na serveru'),
              //   onTap: () async {
              //     try {
              //       const url = "http://192.168.1.7:3000/api/add-user";
              //       final http.Response body = await http.post(url, body:  {
              //         "username": "imranspa",
              //         "userID" : "3isdafna48asncmajfas"
              //       });

              //       if(body.statusCode>=300) {
              //         print("ERROR => ${body.body}");
              //       }
              //       print(body.body);
              //     } catch (e) {
              //       print("Error - $e");
              //     }
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
