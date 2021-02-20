import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semir_potrosnja/view/homeScreen/widgets/addNewCategoryDialog.dart';

class ShowAddCategoryDialogService {
  showAddCategoryDialog(
      BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(children: <Widget>[
              Container(height: 230, width: 400, child: AddNewCategoryDialog()),
            ])).then((value) {
      if (value == 'error') {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              'Pogrešan unos, naziv ne smije biti prazan ili duži od 25 znakova'),
        ));
      }
    });
  }
}
