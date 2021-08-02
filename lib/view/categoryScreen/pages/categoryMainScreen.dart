import 'package:expen/models/Category.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import 'package:expen/utils/speedDial.dart';
import 'package:expen/view/categoryScreen/widgets/categoryMain/expenseGridTile.dart';
import 'package:expen/view/categoryScreen/widgets/categoryMain/expenseListTile.dart';
import 'package:expen/view/categoryScreen/widgets/categoryMain/subcategoryTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:expen/providers/settingsNotifier.dart';

class CategoryMainScreen extends StatefulWidget {
  final Category category;
  final bool isDrawer;

  CategoryMainScreen({this.category, this.isDrawer});

  @override
  _CategoryMainScreenState createState() => _CategoryMainScreenState();
}

class _CategoryMainScreenState extends State<CategoryMainScreen> {
  @override
  Widget build(BuildContext context) {
    final SettingsNotifier settingsNotifier =
        Provider.of<SettingsNotifier>(context);
    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(context, listen: false);
    final SubcategoryNotifier subcategoryNotifier =
        Provider.of<SubcategoryNotifier>(context, listen: false);
    return Scaffold(
      floatingActionButton: buildSpeedDial(context, widget.category),
      appBar: AppBar(
        title: Text(widget.category.naziv),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 5, bottom: 5),
              child: widget.isDrawer
                  ? CircleAvatar(
                      radius: 25,
                      backgroundImage: widget.category.slikaUrl ==
                              'assets/images/nema-slike.jpg'
                          ? AssetImage(widget.category.slikaUrl)
                          : MemoryImage(
                              widget.category.slikaEncoded,
                            ),
                    )
                  : Hero(
                      tag: widget.category.id,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: widget.category.slikaUrl ==
                                'assets/images/nema-slike.jpg'
                            ? AssetImage(widget.category.slikaUrl)
                            : MemoryImage(
                                widget.category.slikaEncoded,
                              ),
                      ),
                    ))
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(children: <Widget>[
              Container(
                height: min(
                    subcategoryNotifier.subcategoriesByCategory.length * 60.0,
                    double.infinity),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: subcategoryNotifier.subcategoriesByCategory.length,
                  itemBuilder: (ctx, index) {
                    return SubcategoryTile(
                        subcategory: subcategoryNotifier.subcategoriesByCategory[index],
                        category: widget.category);
                  },
                ),
              ),
              settingsNotifier.vertikalniPrikaz
                  ? Container(
                      height: min(
                          expenseNotifier.expensesByCategory.length * 80.0,
                          double.infinity),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: expenseNotifier.expensesByCategory.length,
                          itemBuilder: (ctx, index) {
                            return ExpenseListTile(
                              expense:
                                  expenseNotifier.expensesByCategory[index],
                            );
                          }),
                    )
                  : Container(
                      height: expenseNotifier.expensesByCategory.length <= 4
                          ? 140.0
                          : expenseNotifier.expensesByCategory.length % 4 == 0
                              ? (expenseNotifier.expensesByCategory.length /
                                      4) *
                                  140.0
                              : (expenseNotifier.expensesByCategory.length / 4 +
                                      1) *
                                  150.0,
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: expenseNotifier.expensesByCategory.length,
                          padding: EdgeInsets.all(10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 4 / 5,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (ctx, index) {
                            return ExpenseGridTileView(
                              expense:
                                  expenseNotifier.expensesByCategory[index],
                            );
                          }),
                    ),
            ]),
          ],
        ),
      ),
    );
  }
}
