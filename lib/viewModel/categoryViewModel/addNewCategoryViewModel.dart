
import 'package:flutter/material.dart';
import 'package:semir_potrosnja/services/categoryServices/addNewCategoryService.dart';

addNewCategory(BuildContext context, TextEditingController fieldController) {
  return AddNewCategoryService().addNewCategory(context, fieldController);
}