import 'dart:async';
import 'dart:convert';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/providers/profileNotifier.dart';
import 'package:expen/utils/error_dialog.dart';
import 'package:expen/utils/loader.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:expen/utils/global_variables.dart';

class DataSyncService {
  uploadDataToServer(BuildContext context) async {
    showExpenLoader(context);
    final profileNotifier =
        Provider.of<ProfileNotifier>(context, listen: false);
    final CategoryNotifier categoryNotifier =
        Provider.of<CategoryNotifier>(context, listen: false);
    List<Map<String, dynamic>> categoryData = [];
    categoryData = categoryNotifier.kategorijaLista.map((category) {
      return {"id": category.id, "name": category.naziv};
    }).toList();
    final Dio dio = Dio();
    CancelToken token = CancelToken();
    Timer(Duration(seconds: 10), () {
      token.cancel("cancelled");
    });
    final url =
        '$apiURL/sync-data/${profileNotifier.userData["username"]}/${profileNotifier.userData["accessToken"]}';

    print("url =$url");
    try {
      final Response response = await dio.post(url,
          data: jsonEncode({"categoryData": categoryData}), cancelToken: token);

      print("response.dataaa = ${response.data}");
    } catch (e) {
      if (CancelToken.isCancel(e)) {
        print("canceled request");
        showErrorDialog(context, "Server ne odgovara",
            "Zahtjev za kreiranjem profila je istekao");
      }
    }
    popExpenLoader();
  }
}
