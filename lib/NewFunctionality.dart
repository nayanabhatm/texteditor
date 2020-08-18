import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'SaveFunctionality.dart';
import 'constantsFile.dart';

class NewOption{
    String filenameEntered='';
    Future<dynamic> new1(BuildContext context,String currentTextData){
      if(currentTextData!=null)
      {
      return Alert(
          context: context,
          title: 'Save Current File?',
          style: kAlertStyle,
          buttons: [
            DialogButton(
              color: Colors.teal,
              onPressed: () async {
                SaveOption saveOption=await SaveOption();
                await saveOption.save(context,currentTextData);
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
                style:kButtonStyle,
              ),
            )
          ]
      ).show();
      }
    }
}