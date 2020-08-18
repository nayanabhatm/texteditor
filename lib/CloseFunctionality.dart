import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';
import 'constantsFile.dart';

class CloseOption {

  Future<bool> close(BuildContext context) {
    return Alert(
        context: context,
        title: 'Do You Want to Exit?',
        style: kAlertStyle,
        buttons: [
          DialogButton(
            color: Colors.teal,
            onPressed: () async {
              exit(0);
            },
            child: Text(
              "Yes",
              style: kButtonStyle,
            ),
          ),
          DialogButton(
            color: Colors.teal,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "No",
              style: kButtonStyle,
            ),
          )
        ]
    ).show();
  }
}