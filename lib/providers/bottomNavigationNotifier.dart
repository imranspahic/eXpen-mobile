import 'package:flutter/material.dart';

class BottomNavigationNotifier extends ChangeNotifier {
  int categoryNavigationIndex = 0;
  int subcategoryNavigationIndex = 0;

  void onCategoryNavigationChange(int index) {
    categoryNavigationIndex = index;
    notifyListeners();
  }

  void onSubcategoryNavigationChange(int index) {
    subcategoryNavigationIndex = index;
    notifyListeners();
  }

  List<BottomNavigationBarItem> categoryNavigationItems(BuildContext context) {
    return [
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.category),
        label: 'Lista potrošnji',
      ),
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.info_outline),
        label: 'Detalji',
      ),
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.attach_money),
        label: 'Rashod',
      ),
    ];
  }

  List<BottomNavigationBarItem> subcategoryNavigationItems(
      BuildContext context) {
    return [
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.category),
        label: 'Lista potrošnji',
      ),
      BottomNavigationBarItem(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.info_outline),
        label: 'Detalji',
      ),
    ];
  }
}
