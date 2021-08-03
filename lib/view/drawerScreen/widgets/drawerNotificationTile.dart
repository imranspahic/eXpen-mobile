import 'package:expen/providers/notificationNotifier.dart';
import 'package:expen/view/obavijesti_ekran.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DrawerNotificationTile extends StatelessWidget {
  final NotificationModel notification;

  DrawerNotificationTile({@required this.notification});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return ObavijestiEkran(
            otvorenaObavijest: notification,
          );
          //obavijest pass
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.cyan[100],
        ),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        height: 60,
        child: FittedBox(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.notifications_active,
                    size: 25,
                    color: Colors.red[700],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: AutoSizeText(
                    notification.sadrzaj,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700]),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
