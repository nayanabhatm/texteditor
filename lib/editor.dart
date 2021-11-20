import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:texteditor/close_file.dart';
import 'package:texteditor/constants/constants.dart';
import 'package:texteditor/new_file.dart';
import 'package:texteditor/open_file.dart';
import 'package:texteditor/save_file.dart';

class Editor extends StatefulWidget {
  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  String userEnteredData;
  String findOrReplaceFlag, searchText, replaceText;
  int findStartOffset = 0, findEndOffset = 0;
  int findUpKeyOrDownKeyCounter = -1, findUpKeyOrDownKeyFlag = 0;
  List<int> findMatchedTextList = [];
  Iterable<RegExpMatch> findMatches;
  RegExp regexForFind, regexForReplace;
  int replaceOrReplaceAllFlag = 0;

  TextEditingController fileContentController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  TextEditingController replaceTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // foregroundColor: Colors.teal,
        // backgroundColor: Colors.teal,
        title: Text(
          'Text Editor',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: editorDrawer(context),
      body: Container(
        child: findSelectedOrNot(context),
        //if find selected, create new body.
      ),
    );
  }

  Widget editorDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: AppBar().preferredSize.height,
            child: Center(
              child: Text(
                'Editor Options',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
          ),
          ListTile(
            leading: Icon(Icons.save),
            title: Text('Save'),
            onTap: () {
              SaveFile saveOption = SaveFile();
              saveOption.save(context, userEnteredData);
            },
          ),
          ListTile(
            leading: Icon(Icons.folder_open),
            title: Text('Open'),
            onTap: () async {
              OpenFile openOption = OpenFile();
              String fileContents = await openOption.open();
              setState(() {
                userEnteredData = fileContents;
                fileContentController.text = userEnteredData;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.add_box),
            title: Text('New'),
            onTap: () async {
              if (fileContentController.text.length > 0) {
                NewFile newOption = NewFile();
                await newOption.newFile(context, userEnteredData);
                fileContentController.text = '';
                Navigator.pop(context);
              } else {
                fileContentController.text = '';
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.find_in_page),
            title: Text('Find'),
            onTap: () {
              if (fileContentController.text.length > 0) {
                setState(() {
                  findOrReplaceFlag = 'find';
                });
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.find_replace),
            title: Text('Replace'),
            onTap: () {
              if (fileContentController.text.length > 0) {
                setState(() {
                  findOrReplaceFlag = 'replace';
                });
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Close'),
            onTap: () {
              CloseFile close = CloseFile();
              close.close(context);
            },
          ),
        ],
      ),
    );
  }

  Widget findSelectedOrNot(BuildContext context) {
    if (findOrReplaceFlag == 'find') {
      return Column(
        children: <Widget>[
          Expanded(
            child: textEditorBody(),
          ),
          find(),
        ],
      );
    } else if (findOrReplaceFlag == 'replace') {
      return Column(
        children: <Widget>[
          Expanded(
            child: textEditorBody(),
          ),
          find(),
          SizedBox(
            height: 8.0,
          ),
          replace(),
        ],
      );
    } else {
      return textEditorBody();
    }
  }

  Widget textEditorBody() {
    return TextField(
      controller: fileContentController,
      style: TextStyle(
        fontSize: 20.0,
      ),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '  Text Goes Here',
      ),
      onChanged: (value) {
        userEnteredData = value;
      },
    );
  }

  Row find() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 4,
          child: TextField(
            controller: searchTextController,
            onChanged: (value) {
              setState(() {
                findUpKeyOrDownKeyCounter = -1;
                findSubmit();
              });
            },
            decoration: InputDecoration(
              labelText: 'Find Text',
              focusColor: Colors.white,
              enabledBorder: kEnabledBorder,
              focusedBorder: kFocusedBorder,
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: DialogButton(
            color: Colors.teal,
            child: Icon(Icons.arrow_downward),
            onPressed: () {
              setState(() {
                findUpKeyOrDownKeyFlag = 0;
                findUpDownFunction();
              });
            },
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: DialogButton(
            color: Colors.teal,
            child: Icon(Icons.arrow_upward),
            onPressed: () {
              findUpKeyOrDownKeyFlag = 1;
              findUpDownFunction();
            },
          ),
        ),
        SizedBox(
          width: 10.0,
        )
      ],
    );
  }

  Row replace() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 4,
          child: TextField(
            controller: replaceTextController,
            onChanged: (value) {
              replaceText = replaceTextController.text;
            },
            decoration: InputDecoration(
              labelText: 'Replace With',
              focusColor: Colors.white,
              enabledBorder: kEnabledBorder,
              focusedBorder: kFocusedBorder,
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: DialogButton(
            color: Colors.teal,
            child: Text("Replace"),
            onPressed: () {
              replaceOrReplaceAllFlag = 0;
              replaceOnSubmit();
            },
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: DialogButton(
            color: Colors.teal,
            child: Text("Replace\nAll"),
            onPressed: () {
              replaceOrReplaceAllFlag = 1;
              replaceOnSubmit();
            },
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  void findSubmit() {
    findMatchedTextList.clear();
    searchText = searchTextController.text;

    regexForFind = RegExp(searchText);
    findMatches = regexForFind.allMatches(userEnteredData);

    findMatches.forEach((element) {
      findMatchedTextList.add(element.start);
    });
  }

  void findUpDownFunction() {
    setState(() {
      if (findMatchedTextList.isNotEmpty) {
        if (findUpKeyOrDownKeyFlag == 0) {
          if (findUpKeyOrDownKeyCounter == -1) {
            findUpKeyOrDownKeyCounter = 0;
          } else if (findUpKeyOrDownKeyCounter >= 0 &&
              findUpKeyOrDownKeyCounter < findMatchedTextList.length - 1) {
            findUpKeyOrDownKeyCounter++;
          }
        } else if (findUpKeyOrDownKeyFlag == 1) {
          if (findUpKeyOrDownKeyCounter == -1) {
            findUpKeyOrDownKeyCounter = findMatchedTextList.length - 1;
          } else if (findUpKeyOrDownKeyCounter > 0) {
            findUpKeyOrDownKeyCounter--;
          }
        }

        findStartOffset = findMatchedTextList[findUpKeyOrDownKeyCounter];
        findEndOffset = findStartOffset + searchText.length;
      } else {
        findStartOffset = 0;
        findEndOffset = 0;
      }

      fileContentController.selection = TextSelection(
        baseOffset: findStartOffset,
        extentOffset: findEndOffset,
      );
    });
  }

  void replaceOnSubmit() {
    setState(() {
      if (replaceOrReplaceAllFlag == 0) {
        fileContentController.text =
            fileContentController.text.replaceFirst(searchText, replaceText);
      } else {
        fileContentController.text =
            fileContentController.text.replaceAll(searchText, replaceText);
      }
    });
  }
}
