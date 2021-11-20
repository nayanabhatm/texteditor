import 'package:flutter/material.dart';
import 'package:texteditor/editor.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
      ),
      home: Editor(),
    ),
  );
}
