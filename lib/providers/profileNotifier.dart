import 'package:expen/viewModel/userViewModel/setUserDataSharedPrefsVM.dart';
import 'package:flutter/cupertino.dart';

class ProfileNotifier extends ChangeNotifier {
  bool hasProfile = false;

  Map<String, dynamic> userData = {};

  void checkForProfile(bool status) {
    hasProfile = status;
    notifyListeners();
  }

  void setUserData(dynamic responseData, bool hasListener) {
    print("dynamic response = $responseData");
    userData["accessToken"] = responseData["accessToken"];
    final createdAt = DateTime.parse(responseData["dateCreated"]);
    userData["createdAt"] = createdAt;
    userData["email"] = responseData["email"];
    userData["username"] = responseData["username"];
    setUserDataSharedPrefs(userData);
    if (hasListener) {
      notifyListeners();
    }
  }
}
