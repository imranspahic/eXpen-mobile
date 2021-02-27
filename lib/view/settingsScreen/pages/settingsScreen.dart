import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semir_potrosnja/model/data_provider.dart';
import 'package:semir_potrosnja/view/settingsScreen/widgets/settingsAppBar.dart';
import 'package:semir_potrosnja/view/settingsScreen/widgets/settingsCategoryDelete.dart';
import 'package:semir_potrosnja/view/settingsScreen/widgets/settingsExcelExport.dart';
import 'package:semir_potrosnja/view/settingsScreen/widgets/settingsExpenseDelete.dart';
import 'package:semir_potrosnja/view/settingsScreen/widgets/settingsExpenseView.dart';
import 'package:semir_potrosnja/view/settingsScreen/widgets/settingsHeader.dart';
import 'package:semir_potrosnja/view/settingsScreen/widgets/settingsPasswordChange.dart';
import 'package:semir_potrosnja/view/settingsScreen/widgets/settingsPasswordProtection.dart';
import 'package:semir_potrosnja/view/settingsScreen/widgets/settingsPdfExport.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    final postData = Provider.of<SveKategorije>(context, listen: false);
    postData.fetchAndSetPostavke();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postavkeData = Provider.of<SveKategorije>(context);
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
            ],
          ),
        ),
      ),
    );
  }
}
