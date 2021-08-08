import 'package:flutter/material.dart';

class ReusableWidgets {
  
  static SizedBox verticalSpacing({double size = 20}) {
    return SizedBox(height: size);
  }

  static SizedBox horizontalSpacing({double size = 20}) {
    return SizedBox(width: size);
  }

  ///Show badge (notification style) on top of child widet
  static Widget badge(BuildContext context,
      {@required Widget child, @required String value, Color color}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: color != null ? color : Theme.of(context).primaryColor,
            ),
            constraints: BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        )
      ],
    );
  }
}
