import 'package:expen/services/categoryServices/addNewCategoryService.dart';
import 'package:flutter/material.dart';

class AddNewCategoryDialog extends StatefulWidget {
  @override
  _AddNewCategoryDialogState createState() => _AddNewCategoryDialogState();
}

class _AddNewCategoryDialogState extends State<AddNewCategoryDialog> {
  final categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          padding: EdgeInsets.all(10),
          child: TextField(
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).accentColor,
              letterSpacing: 1,
            ),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                labelText: 'Naziv',
                labelStyle: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor)),
            controller: categoryNameController,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          height: 50,
          width: 250,
          child: RaisedButton(
            child: Text(
              'Dodaj kategoriju',
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () => AddNewCategoryService()
                .addNewCategory(context, categoryNameController),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
