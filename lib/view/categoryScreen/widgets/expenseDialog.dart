import 'package:expen/providers/expenseNotifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDialog extends StatefulWidget {
  final ExpenseModel potrosnja;
  ExpenseDialog({this.potrosnja});
  @override
  _ExpenseDialogState createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<ExpenseDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.43,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(children: <Widget>[
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.payment, color: Colors.orange[700], size: 60),
                    SizedBox(width: 10),
                    Text(
                      widget.potrosnja.naziv,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.orange[800]),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.orange, thickness: 2),
              SizedBox(height: 25),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.monetization_on, color: Colors.amber, size: 40),
                    SizedBox(width: 10),
                    Text(
                      '${widget.potrosnja.trosak} KM',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.date_range, color: Colors.purple, size: 40),
                    SizedBox(width: 10),
                    Text(
                      '${DateFormat('dd.MM.yyyy.').format(widget.potrosnja.datum)}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                  width: 100,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.orange,
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )),
            ]),
          ),
        )
      ],
    );
  }
}
