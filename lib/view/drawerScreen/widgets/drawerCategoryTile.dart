import 'package:expen/models/Category.dart';
import 'package:expen/view/bottomNavigationScreen/pages/categoryBottomNavigationScreen.dart';
import 'package:flutter/material.dart';

class DrawerCategoryTile extends StatelessWidget {
  final Category category;

  DrawerCategoryTile({@required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return CategoryBottomNavigationScreen(category, true);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.orange[200],
        ),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        height: 45,
        child: FittedBox(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.assignment_ind,
                    size: 30,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Text(
                    category.naziv,
                    style: Theme.of(context).textTheme.subtitle1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
