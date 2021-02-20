import 'package:flutter/cupertino.dart';
import 'package:semir_potrosnja/services/categoryServices/changeCategoryNameService.dart';

showChangeCategoryNameDialog(BuildContext context, String categoryID) {
  return ChangeCategoryNameService().showChangeCategoryNameDialog(context, categoryID);
}