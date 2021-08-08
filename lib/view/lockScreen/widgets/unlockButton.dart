import 'package:expen/services/lockServices/unlockService.dart';
import 'package:flutter/material.dart';

class UnlockButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      child: RaisedButton(
          onPressed: () => UnlockService.unlock(context),
          color: Colors.orange,
          child: Text(
            'Otključaj',
            style: Theme.of(context).textTheme.headline5.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }
}