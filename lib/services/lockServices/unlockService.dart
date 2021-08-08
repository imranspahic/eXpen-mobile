import 'package:expen/database/glavni_podaci_database.dart';
import 'package:expen/providers/lockNotifier.dart';
import 'package:expen/services/navigatorServices/navigateToPageService.dart';
import 'package:expen/view/homeScreen/pages/homeScreen.dart';
import 'package:flutter/cupertino.dart';

class UnlockService {
  static void unlock(BuildContext context) async {
    final LockNotifier lockNotifier = LockNotifier();
    final dbData = await DatabaseHelper.fetchTable('postavke');
    final sifra = dbData[0]['sifra'];

    if (lockNotifier.passwordController.text != sifra) {
      lockNotifier.setErrorState(true);
      return;
    }
    lockNotifier.release();
    NavigateToPageService.navigate(context, HomeScreen());
  }
}
