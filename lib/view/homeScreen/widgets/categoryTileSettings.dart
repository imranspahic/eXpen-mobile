import 'package:expen/models/Category.dart';
import 'package:expen/providers/settingsNotifier.dart';
import 'package:expen/services/categoryServices/deleteCategoryService.dart';
import 'package:expen/services/navigatorServices/navigateToPageService.dart';
import 'package:expen/view/categorySettingsScreen/pages/postavke_kategorija.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTileSettings extends StatelessWidget {
  final Category category;
  const CategoryTileSettings({Key key, @required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Consumer<SettingsNotifier>(
            builder: (_, settingsNotifier, __) => settingsNotifier
                    .brisanjeKategorija
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 35,
                      color: Colors.red[600],
                    ),
                    onPressed: () => DeleteCategoryService.delete(category.id))
                : Container(),
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 35,
              color: Colors.grey[600],
            ),
            onPressed: () => NavigateToPageService.navigate(
                context, PostavkeKategorija(kategorija: category)),
          ),
        ],
      ),
    );
  }
}
