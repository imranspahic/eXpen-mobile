import 'package:flutter/cupertino.dart';
import 'package:expen/services/categoryServices/changeCategoryNameService.dart';

showChangeCategoryNameDialog(BuildContext context, String categoryID) {
  return ChangeCategoryNameService().showChangeCategoryNameDialog(context, categoryID);
}