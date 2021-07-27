import 'package:flutter/material.dart';

class NavigateToPageService {
  static navigate(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return widget;
    }));
  }
}
