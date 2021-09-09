import 'package:casia/Database/database.dart';
import 'package:casia/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:casia/Pages/Education/WebPage.dart';
import 'package:casia/Pages/Education/EducationPage.dart';

import '../../app_localizations.dart';
//for the dictionaries
//import '../app_localizations.dart';

class EduMyPage extends StatefulWidget {
  final ValueNotifier<List<RecordObject>> records;
  EduMyPage({Key key, this.records}) : super(key: key);
  @override
  _EduMyPageState createState() => _EduMyPageState();
}

class _EduMyPageState extends State<EduMyPage> {
  bool _isEditingText = false;
  int phraseCount = 0;
  TextEditingController _editingController;
  String initialText = 'Write here a new question';

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
      initialText = AppLocalizations.of(context).translate(initialText);
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
            style: TextStyle(
                backgroundColor: DefaultColors.boxHomePurple,
                color: DefaultColors.textColorOnLight,
                fontFamily: 'lato',
                fontSize: 20.0),
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
                        padding: const EdgeInsets.all(20.0),
                        child: _editTitleTextField()),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: questionButton(
                                    textColor: DefaultColors.textColorOnLight,
                                    icon: Icons.save,
                                    text: records[index].question,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WebPage(
                                                question:
                                                    records[index].question,
                                                url: records[index].url)),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteQuestion(records[index]);
                                    widget.records.notifyListeners();
                                  },
                                  icon: Icon(Icons.delete_sharp),
                                  color: DefaultColors.textColorOnLight,
                                  iconSize: 30,
                                )
                              ]);
                        }),
                  ]));
            }));
  }
}
