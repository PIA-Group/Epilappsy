import 'package:casia/Database/database.dart';
import 'package:casia/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:casia/Pages/Education/WebPage.dart';
import 'package:casia/Pages/Education/EducationPage.dart';
import 'package:casia/main.dart';

import '../../Utils/app_localizations.dart';
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
  //String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: AppLocalizations.of(context)
                                .translate("write here a new question").inCaps),

                        //decoration: InputDecoration.collapsed(fillColor: mycolor),
                        onTap: () {
                          setState(() {
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
                                      url: 'https://www.google.com/search?q=' +
                                          newValue)),
                            );
                          }
                          setState(() {
                            _isEditingText = false;
                          });
                        },
                        autofocus: true,
                        controller: _editingController,
                      ),
                    ),
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
