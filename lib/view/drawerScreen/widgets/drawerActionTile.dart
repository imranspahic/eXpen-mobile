import 'package:expen/services/navigatorServices/navigateToPageService.dart';
import 'package:flutter/material.dart';

class DrawerActionTile extends StatelessWidget {
  final String actionName;
  final IconData actionIcon;
  final Widget navigateTo;

  DrawerActionTile(
      {@required this.actionName,
      @required this.actionIcon,
      @required this.navigateTo});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => NavigateToPageService.navigate(context, navigateTo),
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.orange, width: 1.5),
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(actionIcon, color: Colors.orange[700]),
              SizedBox(width: 10),
              Text(actionName,
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Raleway',
                      color: Colors.orange[700],
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ));
  }
}
