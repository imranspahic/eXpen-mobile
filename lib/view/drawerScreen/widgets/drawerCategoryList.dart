import 'dart:math';
import 'package:expen/models/Category.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/view/drawerScreen/widgets/drawerCategoryTile.dart';
import 'package:flutter/material.dart';

class DrawerCategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CategoryNotifier categoryNotifier =
        Provider.of<CategoryNotifier>(context, listen: false);
    final List<Category> categories = categoryNotifier.kategorijaLista;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black26, width: 1)),
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: min(
              categories.length * 52.5 +
                  categories.length * 5 +
                  (5 - categories.length),
              double.infinity),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 5),
              itemCount: categories.length,
              itemBuilder: (ctx, index) {
                return DrawerCategoryTile(category: categories[index]);
              }),
        ),
      ],
    );
  }
}
