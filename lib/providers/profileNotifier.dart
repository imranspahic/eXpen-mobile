import 'package:flutter/cupertino.dart';

class ProfileNotifier extends ChangeNotifier {
  bool hasProfile = false;

  void checkForProfile(bool status) {
    hasProfile = status;
    notifyListeners();
  }
}