import 'dart:math';

import 'package:expen/providers/notificationNotifier.dart';
import 'package:expen/view/drawerScreen/widgets/drawerNotificationTile.dart';
import 'package:expen/view/obavijesti_ekran.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerNotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NotificationNotifier notificationNotifier =
        Provider.of<NotificationNotifier>(context);

    final List<NotificationModel> unreadNotificatioms =
        notificationNotifier.listaNeprocitanihObavijesti();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black26, width: 1)),
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: min(
                  unreadNotificatioms.length * 70.5 +
                      unreadNotificatioms.length * 5 +
                      (5 - unreadNotificatioms.length),
                  220),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  itemCount: unreadNotificatioms.length,
                  itemBuilder: (ctx, index) {
                    return DrawerNotificationTile(
                        notification: unreadNotificatioms[index]);
                  }),
            ),
          ],
        ),
        if (unreadNotificatioms.length > 3)
          Center(
            child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return ObavijestiEkran();
                  }));
                },
                child: Text(
                  'Prikaži još ${unreadNotificatioms.length - 3}...',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red[600]),
          ),
      ],
    );
  }
}
