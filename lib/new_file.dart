import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'constants/constants.dart';
import 'save_file.dart';

class NewFile {
  String filenameEntered = '';
  Future<dynamic> newFile(BuildContext context, String currentTextData) {
    return Alert(
      context: context,
      title: 'Save Current File?',
      style: kAlertStyle,
      buttons: [
        DialogButton(
          color: Colors.teal,
          onPressed: () async {
            SaveFile saveOption = SaveFile();
            await saveOption.save(context, currentTextData ?? '');
            Navigator.pop(context);
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
            "Discard",
            style: kButtonStyle,
          ),
        )
      ],
    ).show();
  }
}
