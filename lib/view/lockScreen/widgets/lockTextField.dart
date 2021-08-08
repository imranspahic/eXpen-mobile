import 'package:expen/providers/lockNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LockTextField extends StatefulWidget {
  @override
  _LockTextFieldState createState() => _LockTextFieldState();
}

class _LockTextFieldState extends State<LockTextField> {
  @override
  void initState() {
    LockNotifier().initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LockNotifier lockNotifier = Provider.of<LockNotifier>(context);
    return Container(
      width: 200,
      child: TextField(
        onTap: () => lockNotifier.setErrorState(false),
        focusNode: lockNotifier.focusNode,
        decoration: InputDecoration(
          hintText: 'Unesite šifru!',
          hintStyle: TextStyle(color: Colors.yellow[700]),
        ),
        textAlign: TextAlign.center,
        obscureText: true,
        controller: lockNotifier.passwordController,
      ),
    );
  }
}
