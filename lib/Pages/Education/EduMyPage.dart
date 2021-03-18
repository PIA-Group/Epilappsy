import 'package:epilappsy/main.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/Pages/Education/WebPage.dart';
import 'package:epilappsy/Pages/Education/EducationPage.dart';
//for the dictionaries
//import '../app_localizations.dart';

class EduMyPage extends StatefulWidget {
  ValueNotifier<List<RecordObject>> records;
  EduMyPage({Key key, this.records}) : super(key: key);
  @override
  _EduMyPageState createState() => _EduMyPageState();
}

class _EduMyPageState extends State<EduMyPage> {
  bool _isEditingText = false;
  int phraseCount = 0;
  TextEditingController _editingController;
  String initialText = 'Write here';

  //String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _editTitleTextField() {
      if (_isEditingText)
        return Center(
          child: TextField(
            //decoration: InputDecoration.collapsed(fillColor: mycolor),
            onTap: () {
              setState(() {
                initialText = '';
                _isEditingText = true;
              });
            },
            onSubmitted: (newValue) {
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPage(
                          records: widget.records,
                          question: newValue,
                          url: 'https://www.google.com/search?q=' + newValue)),
                );
              }
              setState(() {
                initialText = newValue;
                _isEditingText = false;
              });
            },
            autofocus: true,
            controller: _editingController,
          ),
        );
      return InkWell(
          onTap: () {
            setState(() {
              _isEditingText = true;
              initialText = '';
            });
          },
          child: Text(
            initialText,
            style: Theme.of(context).textTheme.bodyText1,
          ));
    }

    return Scaffold(
        body: ValueListenableBuilder(
            // listens to changes in the variable widget.records
            valueListenable: widget.records,
            builder: (BuildContext context, List records, Widget child) {
              return SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _editTitleTextField()),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          return questionButton(
                            textColor: Theme.of(context).accentColor,
                            icon: Icons.save,
                            text: records[index].question,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebPage(
                                        question: records[index].question,
                                        url: records[index].url)),
                              );
                            },
                          );
                        }),
                  ]));
            }));
  }
}
