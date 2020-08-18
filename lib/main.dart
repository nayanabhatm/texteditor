
import 'package:flutter/material.dart';
import 'package:texteditor/constantsFile.dart';
import 'package:texteditor/CloseFunctionality.dart';
import 'NewFunctionality.dart';
import 'SaveFunctionality.dart';
import 'OpenFunctionality.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'constantsFile.dart';

void main(){
  runApp(
      MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
      ),
      home:Editor()
  )
  );
}

class Editor extends StatefulWidget {
  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {

  String userEnteredData;
  String findOrReplaceFlag,searchText,replaceText;
  int findStartOffset=0,findEndOffset=0;
  int findUpKeyOrDownKeyCounter=-1,findUpKeyOrDownKeyFlag=0;
  List<int> findMatchedTextList=List();
  Iterable<RegExpMatch> findMatches;
  RegExp regexForFind,regexForReplace;
  int replaceOrReplaceAllFlag=0;


  TextEditingController fileContentController=TextEditingController();
  TextEditingController searchTextController=TextEditingController();
  TextEditingController replaceTextController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Text Editor'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: AppBar().preferredSize.height,
              child: Center(
                child: Text('Editor Options',
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
              onTap: (){
                SaveOption saveOption=SaveOption();
                saveOption.save(context,userEnteredData);
              },
            ),
            ListTile(
              leading: Icon(Icons.folder_open),
              title: Text('Open'),
              onTap: () async {
                  OpenOption openOption=OpenOption();
                  String fileContents=await openOption.open();
                  setState(() {
                     userEnteredData=fileContents;
                     fileContentController.text=userEnteredData;
                  });
                  Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box),
              title: Text('New'),
              onTap: () async{
                 if(fileContentController.text.length>0) {
                   NewOption newOption = NewOption();
                   await newOption.new1(context, userEnteredData);
                   fileContentController.text = '';
                   Navigator.pop(context);
                 }
                 else{
                   fileContentController.text = '';
                   Navigator.pop(context);
                 }
              },
            ),
            ListTile(
              leading: Icon(Icons.find_in_page),
              title: Text('Find'),
              onTap: (){
                if(fileContentController.text.length>0)
                {
                  setState(() {
                    findOrReplaceFlag='find';
                  });
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.find_replace),
              title: Text('Replace'),
              onTap: (){
                if(fileContentController.text.length>0)
                {
                  setState(() {
                    findOrReplaceFlag='replace';
                  });
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Close'),
              onTap: (){
                  CloseOption close=CloseOption();
                  close.close(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: FindSelectedOrNot(context),
        //if find selected, create new body.
      ),
//      bottomNavigationBar: BottomNavigationBar(
//        items: const <BottomNavigationBarItem> [
//          BottomNavigationBarItem(
//              icon: Icon(Icons.undo),
//              title: Text("Undo"),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.redo),
//            title: Text("Redo"),
//          )
//        ],
//        selectedItemColor: Colors.tealAccent,
//        onTap: (index){
//          print(index);
//          setState(() {
//
//          });
//        },
//      ),
    );
  }

  Widget FindSelectedOrNot(BuildContext context)
  {
    if(findOrReplaceFlag=='find')
    {
      return Column(
        children: <Widget>[
          Expanded(
            child: TextEditorBody(),
          ),
          find(),
        ],
      );
    }
    else if(findOrReplaceFlag=='replace')
    {
      return Column(
        children: <Widget>[
          Expanded(
            child: TextEditorBody(),
          ),
          find(),
          SizedBox(height: 8.0,),
          replace(),
        ],
      );
    }
    else{
      return TextEditorBody();
    }
  }

  Widget TextEditorBody()
  {
    return TextField(
      controller: fileContentController,
      style: TextStyle(
          fontSize: 20.0,
      ),
      maxLines: null,
      keyboardType:TextInputType.multiline,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: ' Text Goes Here',
      ),
      onChanged: (value){
        userEnteredData=value;
      },
    );
  }

  Row find() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 10.0,),
        Expanded(
          flex: 4,
          child: TextField(
            controller: searchTextController,
            onChanged: (value){
              setState(() {
                findUpKeyOrDownKeyCounter=-1;
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
        SizedBox(width: 10.0,),
        Expanded(
          child: DialogButton(
              color: Colors.teal,
              child: Icon(Icons.arrow_downward),
            onPressed: (){
                setState(() {
                  findUpKeyOrDownKeyFlag=0;
                  findUpDownFunction();
                });
            },
          ),
        ),
        SizedBox(width: 10.0,),
        Expanded(
          child: DialogButton(
              color: Colors.teal,
              child: Icon(Icons.arrow_upward),
            onPressed: (){
              findUpKeyOrDownKeyFlag=1;
              findUpDownFunction();
            },
          ),
        ),
        SizedBox(width: 10.0,)
      ],
    );
  }

  Row replace() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 10.0,),
        Expanded(
          flex: 4,
          child: TextField(
            controller: replaceTextController,
            onChanged: (value){
              replaceText=replaceTextController.text;
            },
            decoration: InputDecoration(
              labelText: 'Replace With',
              focusColor: Colors.white,
              enabledBorder: kEnabledBorder,
              focusedBorder: kFocusedBorder,
            ),
          ),
        ),
        SizedBox(width: 10.0,),
        Expanded(
          child: DialogButton(
            color: Colors.teal,
            child: Text("Replace"),
            onPressed: (){
              replaceOrReplaceAllFlag=0;
              replaceOnSubmit();
            },
          ),
        ),
        SizedBox(width: 10.0,),
        Expanded(
          child: DialogButton(
              color: Colors.teal,
              child: Text("Replace\nAll"),
            onPressed: (){
              replaceOrReplaceAllFlag=1;
              replaceOnSubmit();
            },
          ),
        ),
        SizedBox(width: 10.0,),
      ],
    );
  }

  void findSubmit(){
    findMatchedTextList.clear();
    searchText=searchTextController.text;

    print(searchText);

    regexForFind = RegExp(searchText);
    findMatches = regexForFind.allMatches(userEnteredData);

    findMatches.forEach((element) {
      findMatchedTextList.add(element.start);
      print(userEnteredData.substring(element.start, element.end));
    });
  }

  void findUpDownFunction(){
    setState(() {
      if(findMatchedTextList.isNotEmpty)
      {
            print("$searchText .... $findMatchedTextList");

            if (findUpKeyOrDownKeyFlag == 0) {
              if (findUpKeyOrDownKeyCounter == -1) {
                findUpKeyOrDownKeyCounter = 0;
              }
              else if (findUpKeyOrDownKeyCounter >= 0 && findUpKeyOrDownKeyCounter < findMatchedTextList.length - 1) {
                findUpKeyOrDownKeyCounter++;
              }
            }
            else if (findUpKeyOrDownKeyFlag == 1) {
              if (findUpKeyOrDownKeyCounter == -1) {
                findUpKeyOrDownKeyCounter = findMatchedTextList.length - 1;
              }
              else if (findUpKeyOrDownKeyCounter > 0) {
                findUpKeyOrDownKeyCounter--;
              }
            }

            findStartOffset = findMatchedTextList[findUpKeyOrDownKeyCounter];
            findEndOffset = findStartOffset + searchText.length;

            print(findMatchedTextList);
            print("$findStartOffset $findEndOffset");
            print("counter  $findUpKeyOrDownKeyCounter");
      }
      else{
        findStartOffset=0;
        findEndOffset=0;
      }


      fileContentController.selection = TextSelection(
        baseOffset: findStartOffset,
        extentOffset: findEndOffset,
      );

    });
  }

  void replaceOnSubmit(){
    setState(() {
        print(searchText);
        print(replaceText);
        print(userEnteredData);

        if(replaceOrReplaceAllFlag==0){
          fileContentController.text=fileContentController.text.replaceFirst(searchText,replaceText);
        }
        else{
          fileContentController.text=fileContentController.text.replaceAll(searchText,replaceText);
        }
    });
  }

}

