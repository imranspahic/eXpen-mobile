import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semir_potrosnja/model/data_provider.dart';
import 'package:semir_potrosnja/view/categorySettingsScreen/widgets/changeCategoryNameDialog.dart';
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
    final katData = Provider.of<KategorijaLista>(context, listen: false);
    katData.updateNazivKategorije(naziv, categoryID);
    Navigator.of(context).pop('promijenjeno');
  }
}
