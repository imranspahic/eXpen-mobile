import 'package:flutter/material.dart';

class LockExpenHeadline extends StatelessWidget {
  const LockExpenHeadline({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            width: 70,
            height: 70,
            child: Image.asset(
              'assets/images/logo_coin.png',
              fit: BoxFit.cover,
            )),
        SizedBox(width: 10),
        FittedBox(
          child: RichText(
              text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 90),
                  children: [
                TextSpan(text: 'e'),
                TextSpan(
                  text: 'X',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                      fontSize: 90,
                      color: Colors.yellow[600],
                      fontWeight: FontWeight.w400),
                ),
                TextSpan(text: 'pen'),
              ])),
        ),
      ],
    );
  }
}
