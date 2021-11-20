import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:texteditor/constants/constants.dart';

import 'constants/constants.dart';
import 'file_storage.dart';

class SaveFile {
  String filenameEntered = '';

  Future<bool> save(BuildContext context, String userEnteredData) {
    return Alert(
      context: context,
      title: 'Save As',
      style: kAlertStyle,
      content: Column(
        children: [
          TextField(
            onChanged: (value) {
              filenameEntered = value;
            },
            decoration: InputDecoration(
                labelText: 'Filename', focusColor: Colors.white),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          color: Colors.teal,
          onPressed: () {
            if (filenameEntered.length > 0) {
              FileStorage().saveFile(userEnteredData, filenameEntered);
              Navigator.pop(context);
            } else {
              Alert(
                context: context,
                title: "Enter the File Name",
                style: kAlertStyle,
                buttons: [
                  DialogButton(
                    color: Colors.teal,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: kButtonStyle,
                    ),
                  )
                ],
              ).show();
            }
          },
          child: Text(
            "Save",
            style: kButtonStyle,
          ),
        ),
        DialogButton(
          color: Colors.teal,
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: kButtonStyle,
          ),
        )
      ],
    ).show();
  }
}
