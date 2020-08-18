import 'dart:io' show Platform,File,Directory;
import 'package:path_provider/path_provider.dart' as pathProvider;

class FileStorage{

  Future<String> get localPath async{
    Directory externalStorageDirectory;
    String path;
    if(Platform.isAndroid)
        externalStorageDirectory=await pathProvider.getExternalStorageDirectory();
    else if(Platform.isWindows)
        externalStorageDirectory=await pathProvider.getDownloadsDirectory();
    path=externalStorageDirectory.path;
    if (path == null)
      return null;
    else
      return path;
  }

  Future<File> saveFile(String data,String fileName) async{
    final path=await localPath;
    final file=File('$path/$fileName.txt');
    return file.writeAsString(data);
  }

  Future<String> readContent(File filePath) async {
    print(filePath);
    try {
      final file = await filePath;
      String fileContents = await file.readAsString();
      // Returning the contents of the file
      print(fileContents);
      return fileContents;
    } catch (e) {
      // If encountering an error, return
      return 'Error';
    }
  }

}
