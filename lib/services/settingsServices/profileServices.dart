import 'package:expen/database/glavni_podaci_database.dart';
import 'package:expen/providers/profileNotifier.dart';
import 'package:expen/utils/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
    final profileNotifier =
        Provider.of<ProfileNotifier>(context, listen: false);

    const url = "$apiURL/create-user";
    print("request started");
    final response = await http.post(url, body: {
      "applicationToken": applicationToken,
      "email": "imranspahic300@gmail.com",
      "username": "imranspahic"
    });
    print("response arrived = ${response.body}");
    print("responsestatuscode = ${response.statusCode}");
    if (response.statusCode == 200) {
      profileNotifier.checkForProfile(true);
      DatabaseHelper.updateRowInTable('postavke', 'kreiranProfil', 1);
    }
  }
}
