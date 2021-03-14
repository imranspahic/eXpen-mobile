import 'package:expen/utils/fieldDivider.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  final String message1;
  final String message2;
  ErrorDialog({@required this.message1, this.message2});
  @override
  _ErrorDialogState createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          "Greška",
          style: TextStyle(
              fontSize: 25,
              fontFamily: 'Raleway',
              color: Colors.red[700],
              fontWeight: FontWeight.bold,
              letterSpacing: 0),
        ),
      ),
      titlePadding: EdgeInsets.only(top: 10, bottom: 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          FieldDivider(
            mini: true,
          ),
          Text(widget.message1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                  color: Colors.red[500],
                  letterSpacing: 0)),
          if (widget.message2 != null)
            Text(
              widget.message2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                  color: Colors.red[500],
                  letterSpacing: 0),
            ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      actions: [
        FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
              child: Text(
            "OK",
            style: TextStyle(
                fontSize: 19,
                fontFamily: 'Raleway',
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                letterSpacing: 0),
          )),
        ),
      ],
    );
  }
}

void showErrorDialog(BuildContext context, String message1, [String message2]) {
  showDialog(
      context: context,
      builder: (ctx) {
        return ErrorDialog(
          message1: message1,
          message2: message2,
        );
      });
}
