import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'constants/constants.dart';

class CloseFile {
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
      ],
    ).show();
  }
}
