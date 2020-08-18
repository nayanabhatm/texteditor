import 'package:flutter/material.dart';
import 'package:texteditor/constantsFile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';
import 'FileStorage.dart';
import 'constantsFile.dart';


class SaveOption {
    String filenameEntered='';

   Future<bool> save(BuildContext context,String userEnteredData)
   {
    return Alert(
        context: context,
        title: 'Save As',
        style: kAlertStyle,
        content: Column(
          children: [
            TextField(
              onChanged: (value){
                filenameEntered=value;
              },
              decoration: InputDecoration(
                  labelText: 'Filename',
                focusColor: Colors.white
              ),
            ),
          ],
        ) ,
        buttons: [
          DialogButton(
            color: Colors.teal,
            onPressed: () {
              if(filenameEntered.length>0){
                FileStorage().saveFile(userEnteredData,filenameEntered);
                Navigator.pop(context);
              }
              else{
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
                  ]
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
        ]
    ).show();
  }

}

