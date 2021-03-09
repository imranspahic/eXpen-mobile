
import 'package:flutter/material.dart';
import 'package:expen/services/categoryServices/addNewCategoryService.dart';

addNewCategory(BuildContext context, TextEditingController fieldController) {
  return AddNewCategoryService().addNewCategory(context, fieldController);
}