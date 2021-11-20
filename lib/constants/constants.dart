import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

TextStyle kButtonStyle= TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold);
AlertStyle kAlertStyle= AlertStyle(
          animationType: AnimationType.fromBottom,
          animationDuration: Duration(milliseconds: 500),
          titleStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
      ),
      isCloseButton: false,
      );

OutlineInputBorder kEnabledBorder= OutlineInputBorder(
borderRadius: BorderRadius.all(Radius.circular(10.0)),
borderSide: BorderSide(color: Colors.white,width: 1.0,style: BorderStyle.solid)
);

OutlineInputBorder kFocusedBorder= OutlineInputBorder(
borderRadius: BorderRadius.all(Radius.circular(10.0)),
borderSide: BorderSide(color: Colors.white,width: 1.0,style: BorderStyle.solid),
);