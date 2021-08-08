import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';

class DeleteCategoryService {
  static void delete(String categoryID) {
    final ExpenseNotifier expenseNotifier = ExpenseNotifier();
    final SubcategoryNotifier subcategoryNotifier = SubcategoryNotifier();
    final CategoryNotifier categoryNotifier = CategoryNotifier();
    categoryNotifier.izbrisiKategoriju(
        categoryID,
        expenseNotifier.potrosnjePoKategorijilista(categoryID),
        subcategoryNotifier.potKategorijePoKategorijilista(categoryID));
  }
}
