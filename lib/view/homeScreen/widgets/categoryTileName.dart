import 'package:expen/models/Category.dart';
import 'package:flutter/material.dart';

class CategoryTileName extends StatelessWidget {
  final Category category;
  const CategoryTileName({Key key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20,
        right: 10,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            height: 50,
            width: 250,
            color: Colors.black54,
            child: FittedBox(
              child: Text(
                category.naziv,
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.right,
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            )));
  }
}
