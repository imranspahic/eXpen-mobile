import 'package:expen/providers/lockNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LockError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LockNotifier lockNotifier = Provider.of<LockNotifier>(context);
    return lockNotifier.hasError
        ? Column(children: <Widget>[
            Icon(Icons.error, size: 35, color: Colors.red),
            SizedBox(height: 5),
            Text(
              'Netačna šifra!',
              style: TextStyle(color: Colors.red, fontSize: 20),
            )
          ])
        : Container();
  }
}
