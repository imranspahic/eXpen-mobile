import 'package:expen/models/Category.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import 'package:expen/services/navigatorServices/navigateToPageService.dart';
import 'package:expen/services/subcategoryServices/deleteSubcategoryService.dart';
import 'package:expen/view/bottomNavigationScreen/pages/subcategoryBottomNavigationScreen.dart';
import 'package:expen/view/edit_potkategorija_ekran.dart';
import 'package:expen/widgets/badge.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:expen/models/Subcategory.dart';

class SubcategoryTile extends StatelessWidget {
  final Subcategory subcategory;
  final Category category;

  SubcategoryTile({@required this.subcategory, @required this.category});
  @override
  Widget build(BuildContext context) {
    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(context);
    return Dismissible(
      key: ValueKey(subcategory.idPot),
      background: Container(
        padding: EdgeInsets.only(right: 25),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) =>
          DeleteSubcategoryService.delete(context, subcategory.idPot),
      child: ListTile(
          leading: Badge(
            child: Icon(
              IconData(subcategory.icon, fontFamily: 'MaterialIcons'),
              size: 60,
              color: subcategory.bojaIkone,
            ),
            value: expenseNotifier.badge(subcategory.idPot),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              size: 30,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return EditPotkategorijaEkran(subcategory);
              })).then((value) async {
                await Provider.of<SubcategoryNotifier>(context, listen: false)
                    .fetchAndSetPotkategorije();
              });
            },
          ),
          title: Text(subcategory.naziv),
          onTap: () => NavigateToPageService.navigate(context,
              SubcategoryBottomNavigationScreen(subcategory, category))),
    );
  }
}
