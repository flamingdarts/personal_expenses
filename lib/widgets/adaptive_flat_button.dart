import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String title;
  final Function handler;

  AdaptiveFlatButton({this.title, this.handler});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              'Pick date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: handler)
        : FlatButton(
            onPressed: handler,
            child: Text(
              'Pick date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            textColor: Theme.of(context).primaryColor,
          );
  }
}
