import 'package:flutter/cupertino.dart';

class LockNotifier extends ChangeNotifier {
  LockNotifier._internal();
  static final LockNotifier _instance = LockNotifier._internal();
  factory LockNotifier() => _instance;

  TextEditingController passwordController;
  FocusNode focusNode;

  bool hasError = false;

  void initialize() {
    passwordController = TextEditingController();
    focusNode = FocusNode();
  }

  void release() {
    passwordController?.dispose();
    focusNode?.dispose();
  }

  void setErrorState(bool state, {bool hasListener = true}) {
    hasError = state;
    if (hasListener) notifyListeners();
  }
}
