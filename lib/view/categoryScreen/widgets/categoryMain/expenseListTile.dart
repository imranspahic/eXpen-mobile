import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/services/dialogServices/showDialogService.dart';
import 'package:expen/widgets/izbrisi_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:expen/models/Expense.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;

  ExpenseListTile({@required this.expense});
  @override
  Widget build(BuildContext context) {
    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(context);
    return Column(
      children: <Widget>[
        Container(
          height: 80,
          child: Card(
            elevation: 3,
            child: ListTile(
                onTap: () =>
                    ShowDialogService.expenseViewDialog(context, expense),
                leading: Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2, color: Theme.of(context).primaryColor)),
                    child: Text(
                      '${expense.trosak.toStringAsFixed(0)} KM',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor),
                    )),
                title: Text(
                  expense.naziv,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(DateFormat.yMMMd().format(expense.datum)),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return IzbrisiDialog(
                              izbrisi: expenseNotifier.izbrisiPotrosnju,
                              potrosnja: expense,
                            );
                          });
                    })),
          ),
        ),
      ],
    );
  }
}
