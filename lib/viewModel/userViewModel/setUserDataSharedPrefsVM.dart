import 'package:expen/services/sharedPrefsServices/setSharedPrefsService.dart';

setUserDataSharedPrefs(Map<String, dynamic> userData) {
  return SetSharedPrefsService().setUserDataSharedPrefs(userData);
}