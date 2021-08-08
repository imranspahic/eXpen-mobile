import 'package:expen/models/Category.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTileStats extends StatelessWidget {
  final Category category;
  const CategoryTileStats({Key key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.folder,
            size: 35,
            color: Colors.brown[600],
          ),
          SizedBox(
            width: 6,
          ),
          Consumer<SubcategoryNotifier>(
              builder: (_, subcategoryNotifier, __) => Text(
                    subcategoryNotifier
                        .potKategorijePoKategoriji(category.id)
                        .toString(),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800]),
                  )),
          SizedBox(
            width: 6,
          ),
          Icon(
            Icons.work,
            size: 35,
            color: Colors.orange[800],
          ),
          SizedBox(
            width: 6,
          ),
          Consumer<ExpenseNotifier>(
              builder: (_, expenseNotifier, __) => Text(
                    expenseNotifier
                        .potrosnjePoKategoriji(category.id)
                        .toString(),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800]),
                  )),
        ],
      ),
    );
  }
}
