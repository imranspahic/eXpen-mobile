import 'package:flutter/material.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/services/categoryServices/pickCategoryImageService.dart';

pickCategoryImage(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey, CategoryModel category) {
  return PickCategoryImageService().pickCategoryImage(context, _scaffoldKey, category);
}
