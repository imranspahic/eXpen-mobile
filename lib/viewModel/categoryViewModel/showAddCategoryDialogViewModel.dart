
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expen/services/categoryServices/showAddCategoryDialogService.dart';

showAddCategoryDialog(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) {
  return ShowAddCategoryDialogService().showAddCategoryDialog(context, _scaffoldKey);
}