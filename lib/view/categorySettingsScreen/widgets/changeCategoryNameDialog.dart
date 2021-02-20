import 'package:flutter/material.dart';
import 'package:semir_potrosnja/viewModel/categoryViewModel/changeCategoryNameViewModel.dart';

class ChangeCategoryNameDialog extends StatefulWidget {
  final String kategorijaId;
  ChangeCategoryNameDialog({this.kategorijaId});
  @override
  _ChangeCategoryNameDialogState createState() =>
      _ChangeCategoryNameDialogState();
}

class _ChangeCategoryNameDialogState extends State<ChangeCategoryNameDialog> {
  TextEditingController _nazivController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.edit, color: Colors.orange[700], size: 60),
                    SizedBox(width: 10),
                    Text(
                      'Promijeni naziv',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.orange[800]),
                    ),
                  ],
                ),
                Divider(color: Colors.orange, thickness: 2),
                SizedBox(height: 30),
                Container(
                    width: 200,
                    child: TextField(
                      controller: _nazivController,
                      decoration: InputDecoration(hintText: 'Unesi naziv'),
                    )),
                Spacer(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: RaisedButton(
                            onPressed: () => changeCategoryName(
                                _nazivController, context, widget.kategorijaId),
                            color: Colors.orange,
                            child: Text(
                              'Sačuvaj',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )),
                      Container(
                          width: 120,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.grey,
                            child: Text(
                              'Odustani',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )),
                    ])
              ],
            ),
          ),
        )
      ],
    );
  }
}
