import 'package:expen/providers/profileNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class GetSharedPrefsService {
  Future<void> getUserDataSharedPrefs(BuildContext context) async {
    print("not exet");
    final SharedPreferences prefInstance =
        await SharedPreferences.getInstance();
    Map<String, dynamic> responseData = {};

    responseData["username"] = prefInstance.getString("username");
    if (responseData["username"] == null) return;
    responseData["email"] = prefInstance.getString("email");
    print("EXEC");
    responseData["accessToken"] = prefInstance.getString("accessToken");
    final createdAtSharedPrefs = prefInstance.getString("createdAt");
    print("createdAtsp = $createdAtSharedPrefs");
    print(" responseData username = ${responseData["username"]}");
    final createdAt = DateTime.parse(createdAtSharedPrefs);
    responseData["createdAt"] = createdAt;

    print("RESPONSE DATA ACCESSTOKEN = ${responseData["accessToken"]}");
    final profileNotifier =
        Provider.of<ProfileNotifier>(context, listen: false);
    profileNotifier.userData = responseData;
  }
}
