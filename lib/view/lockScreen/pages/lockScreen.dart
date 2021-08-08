import 'package:expen/view/lockScreen/widgets/lockError.dart';
import 'package:expen/view/lockScreen/widgets/lockExpenHeadline.dart';
import 'package:expen/view/lockScreen/widgets/lockTextField.dart';
import 'package:expen/view/lockScreen/widgets/unlockButton.dart';
import 'package:flutter/material.dart';

class LockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LockExpenHeadline(),
              Icon(
                Icons.lock,
                size: 200,
                color: Colors.red,
              ),
              LockTextField(),
              SizedBox(height: 10),
              LockError(),
              SizedBox(height: 10),
              UnlockButton()
            ],
          ),
        ),
      ),
    );
  }
}
