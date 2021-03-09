import 'package:flutter/cupertino.dart';

class ProfileNotifier extends ChangeNotifier {
  bool hasProfile = true;

  void checkForProfile() {

    notifyListeners();
  }
}