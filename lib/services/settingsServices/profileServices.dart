import 'dart:async';
import 'dart:convert';

import 'package:expen/database/glavni_podaci_database.dart';
import 'package:expen/providers/profileNotifier.dart';
import 'package:expen/utils/error_dialog.dart';
import 'package:expen/utils/global_variables.dart';
import 'package:expen/utils/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class ProfileServices {
  static Future<void> getProfileState(BuildContext context) async {
    final data = await DatabaseHelper.fetchTable('postavke');
    final profileNotifier =
        Provider.of<ProfileNotifier>(context, listen: false);
    bool profileStatus = true;
    if (data[0]["kreiranProfil"] == 0) {
      profileStatus = false;
    }
    profileNotifier.checkForProfile(profileStatus);
  }

  static createProfile(BuildContext context) async {
    showExpenLoader(context);
    final Dio dioInstance = Dio();
    CancelToken token = CancelToken();
    Timer(Duration(seconds: 10), () {
      token.cancel("cancelled");
    });
    final profileNotifier =
        Provider.of<ProfileNotifier>(context, listen: false);

    const url = "$apiURL/create-user";

    try {
      final Response response = await dioInstance.post(url,
          data: jsonEncode({
            "applicationToken": applicationToken,
            "email": "imranspahic300@gmail.com",
            "username": "imranspahic",
            "password": "nodeexample"
          }),
          cancelToken: token);
      print("response arrived = ${response.data}");
      print("responsestatuscode = ${response.statusCode}");
      if (response.statusCode == 200) {
        profileNotifier.checkForProfile(true);
        profileNotifier.setUserData(response.data, true);
        DatabaseHelper.updateRowInTable('postavke', 'kreiranProfil', 1);
      } else {
        showErrorDialog(
          context,
          "Nepoznata greška (Kod greške: ${response.statusCode}",
        );
      }
    } catch (e) {
      if (CancelToken.isCancel(e)) {
        print("error $e");
        popExpenLoader();
        showErrorDialog(context, "Server ne odgovara",
            "Zahtjev za kreiranjem profila je istekao");
      }
    }

    popExpenLoader();
  }
}
