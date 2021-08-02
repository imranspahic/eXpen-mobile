
import 'package:expen/models/Expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseGridTileView extends StatelessWidget {
  final Expense expense;
  ExpenseGridTileView({@required this.expense});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: GridTile(
        child: Container(
            margin: EdgeInsets.only(top: 10, right: 5, left: 5, bottom: 60),
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2, color: Theme.of(context).primaryColor)),
            child: FittedBox(
              child: Text(
                '${expense.trosak.toStringAsFixed(0)} KM',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).accentColor),
              ),
            )),
        footer: Container(
          margin: EdgeInsets.only(bottom: 7),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: Text(
                      expense.naziv,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 19),
                    ),
                  )),
              Container(
                alignment: Alignment.center,
                child: Text(DateFormat.yMMMd().format(expense.datum)),
              )
            ],
          ),
        ),
      ),
    );
  }
}