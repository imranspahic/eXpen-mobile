import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/view/categorySettingsScreen/widgets/changeCategoryNameDialog.dart';
import 'package:provider/provider.dart';

class ChangeCategoryNameService {
  showChangeCategoryNameDialog(BuildContext context, String categoryID) {
    showDialog(
        context: context,
        builder: (ctx) {
          return ChangeCategoryNameDialog(kategorijaId: categoryID);
        });
  }

  changeCategoryName(TextEditingController fieldController,
      BuildContext context, String categoryID) {
    final naziv = fieldController.text;
    final katData = Provider.of<CategoryNotifier>(context, listen: false);
    katData.updateNazivKategorije(naziv, categoryID);
    Navigator.of(context).pop('promijenjeno');
  }
}
