import 'dart:io' show File;
import 'package:file_picker/file_picker.dart';
import 'FileStorage.dart';

class OpenOption{

  Future<String> open() async{
    File file = await FilePicker.getFile(
        allowedExtensions: ['txt','log','java','html'],
        type: FileType.custom,
    );

    if(file==null)
      return null;
    else
      {
      String FileContents = await FileStorage().readContent(file);
      print(FileContents);
      return FileContents;
      }

  }
}