import 'package:expen/models/Category.dart';
import 'package:flutter/material.dart';

class CategoryTileImage extends StatelessWidget {
  final Category category;
  const CategoryTileImage({Key key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: category.slikaUrl == 'assets/images/nema-slike.jpg'
          ? Image.asset(
              category.slikaUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            )
          : Hero(
              tag: category.id,
              child: Image.memory(
                category.slikaEncoded,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              ),
            ),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    );
  }
}
