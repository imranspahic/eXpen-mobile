import 'package:flutter/cupertino.dart';
import 'package:semir_potrosnja/services/categoryServices/changeCategoryNameService.dart';

changeCategoryName(TextEditingController fieldController, BuildContext context,
    String categoryID) {
  return ChangeCategoryNameService()
      .changeCategoryName(fieldController, context, categoryID);
}
