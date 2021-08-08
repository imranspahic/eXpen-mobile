import 'package:expen/models/Category.dart';
import 'package:expen/services/categoryServices/openCategoryService.dart';
import 'package:expen/view/homeScreen/widgets/categoryTileImage.dart';
import 'package:expen/view/homeScreen/widgets/categoryTileName.dart';
import 'package:expen/view/homeScreen/widgets/categoryTileSettings.dart';
import 'package:expen/view/homeScreen/widgets/categoryTileStats.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => OpenCategoryService.open(context, category),
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              CategoryTileImage(category: category),
              CategoryTileName(category: category),
            ]),
            Container(
              color: Colors.orangeAccent[100],
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CategoryTileStats(category: category),
                    CategoryTileSettings(category: category),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
