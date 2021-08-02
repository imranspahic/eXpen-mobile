import 'package:expen/providers/homeInitializeNotifier.dart';
import 'package:expen/providers/settingsNotifier.dart';
import 'package:expen/services/homeServices/initializeAppService.dart';
import 'package:expen/utils/loader.dart';
import 'package:expen/utils/size_config.dart';
import 'package:expen/view/homeScreen/pages/homeScreen.dart';
import 'package:expen/view/lockScreen/pages/lockScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WrapperScreen extends StatefulWidget {
  @override
  _WrapperScreenState createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  @override
  void initState() {
    InitializeAppService.initialize(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final HomeInitializeNotifier homeInitializeNotifier =
        Provider.of<HomeInitializeNotifier>(context);
    final SettingsNotifier settingsNotifier =
        Provider.of<SettingsNotifier>(context);
    return homeInitializeNotifier.isInitializing
        ? Scaffold(
            body: ExpenLoader(
            isDialog: false,
          ))
        : settingsNotifier.zastitaLozinkom
            ? LockScreen()
            : HomeScreen();
  }
}
