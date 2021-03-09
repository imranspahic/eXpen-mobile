import 'package:flutter/material.dart';
import 'package:expen/providers/notificationNotifier.dart';
import 'package:provider/provider.dart';
import 'package:expen/view/obavijesti_ekran.dart';
import 'package:expen/viewModel/categoryViewModel/showAddCategoryDialogViewModel.dart';

AppBar homeScreenAppBar(
    BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
  return AppBar(
    title: Row(
      children: <Widget>[
        Image.asset('assets/images/logo_coin_removed.png',
            width: 30, height: 30),
        SizedBox(width: 5),
        Text(
          'eXpen',
          style: TextStyle(color: Colors.black),
        ),
      ],
    ),
    actions: <Widget>[
      IconButton(
          icon:
              Provider.of<NotificationNotifier>(context).neprocitaneObavijesti() == 0
                  ? Icon(Icons.notifications_none)
                  : Icon(Icons.notifications_active),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return ObavijestiEkran();
            }));
          }),
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () => showAddCategoryDialog(context, scaffoldKey))
    ],
  );
}
