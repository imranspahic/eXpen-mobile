import 'package:expen/providers/profileNotifier.dart';
import 'package:expen/utils/error_dialog.dart';
import 'package:expen/view/settingsScreen/widgets/settingsProfileInformation.dart';
import 'package:expen/view/settingsScreen/widgets/settingsSyncCreateProfile.dart';
import 'package:expen/view/settingsScreen/widgets/settinsSyncData.dart';
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
    postData.fetchAndSetPostavke(context, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsNotifier settingsNotifier = Provider.of<SettingsNotifier>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: settingsAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: <Widget>[
              SettingsHeader('Prikaz', Icons.view_carousel),
              SettingsExpenseView(settingsNotifier: settingsNotifier),
              SettingsCategoryDelete(settingsNotifier: settingsNotifier),
              SettingsExpenseDelete(settingsNotifier: settingsNotifier),
              SettingsHeader('Sigurnost', Icons.lock),
              SettingsPasswordProtection(settingsNotifier: settingsNotifier),
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
              SettingsSyncData(),
              ListTile(
                title: Text('Prikaži error'),
                subtitle: Text('Prikaži error dialog'),
                onTap: () async {
                  showErrorDialog(context, "Zahtjev je istekao");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
