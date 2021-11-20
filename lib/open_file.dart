import 'dart:io' show File;

import 'package:file_picker/file_picker.dart';

import 'file_storage.dart';

class OpenFile {
  Future<String> open() async {
    File file = await FilePicker.getFile(
      allowedExtensions: ['txt', 'log', 'java', 'html'],
      type: FileType.custom,
    );

    if (file == null)
      return null;
    else {
      String fileContents = await FileStorage().readContent(file);
      return fileContents;
    }
  }
}
