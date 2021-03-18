import 'package:shared_preferences/shared_preferences.dart';

class SetSharedPrefsService {

  void setUserDataSharedPrefs(Map<String, dynamic> userData) async {
    final prefInstance = await SharedPreferences.getInstance();
    prefInstance.setString("username", userData["username"]);
    prefInstance.setString("email", userData["email"]);
    prefInstance.setString("accessToken", userData["accessToken"]);
    prefInstance.setString("createdAt", userData["createdAt"].toString());
    print("Setting user created at = ${userData["createdAt"]}");
    print("setting date created = ${prefInstance.getString("createdAt")}");
  }
}