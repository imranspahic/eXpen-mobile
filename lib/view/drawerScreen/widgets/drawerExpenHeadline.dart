import 'package:flutter/material.dart';

class DrawerExpenHeadline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 150,
        color: Theme.of(context).primaryColor,
        child: Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo_coin_removed.png',
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(width: 5),
                    RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.headline2,
                          children: [
                            TextSpan(text: 'e'),
                            TextSpan(
                                text: 'X',
                                style: TextStyle(
                                    color: Colors.yellow[500],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50)),
                            TextSpan(text: 'pen'),
                          ]),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Divider(
                    thickness: 3,
                    color: Colors.brown,
                    height: 10,
                  ),
                )
              ],
            )));
  }
}
