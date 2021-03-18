import 'package:expen/services/sharedPrefsServices/getSharedPrefsService.dart';
import 'package:flutter/cupertino.dart';

 Future<void> getUserDataSharedPrefs(BuildContext context) async{
  return GetSharedPrefsService().getUserDataSharedPrefs(context);
}