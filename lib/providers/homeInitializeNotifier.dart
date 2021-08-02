import 'package:flutter/cupertino.dart';

class HomeInitializeNotifier with ChangeNotifier {
  bool isInitializing = true;

  void setInitializing(bool state, {bool hasListener = true}) {
    isInitializing = state;
    if (hasListener) notifyListeners();
  }
}
