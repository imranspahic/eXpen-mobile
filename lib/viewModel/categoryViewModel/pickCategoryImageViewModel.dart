import 'package:flutter/material.dart';
import 'package:semir_potrosnja/model/data_provider.dart';
import 'package:semir_potrosnja/services/categoryServices/pickCategoryImageService.dart';

pickCategoryImage(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey, KategorijaModel category) {
  return PickCategoryImageService().pickCategoryImage(context, _scaffoldKey, category);
}
