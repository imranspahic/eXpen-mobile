import 'package:expen/models/Category.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import 'package:expen/view/bottomNavigationScreen/pages/categoryBottomNavigationScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpenCategoryService {
  static open(BuildContext context, Category category) {
    final ExpenseNotifier expenseNotifier = Provider.of<ExpenseNotifier>(context, listen: false);
    final SubcategoryNotifier subcategoryNotifier = Provider.of<SubcategoryNotifier>(context, listen: false);
    expenseNotifier.setExpensesByCategory(category);
    subcategoryNotifier.setSubcategoriesByCategory(category);
    
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return CategoryBottomNavigationScreen(category, false);
    }));
  }
}
