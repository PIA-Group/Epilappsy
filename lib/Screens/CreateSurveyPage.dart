import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Pages/SurveyPage.dart';
import 'package:flutter/material.dart';


//for the dictionaries
import '../app_localizations.dart';


class CreateSurveyPage extends StatefulWidget {
  @override
  _CreateSurveyPageState createState() => _CreateSurveyPageState();
}

class _CreateSurveyPageState extends State<CreateSurveyPage> {
  final TextEditingController eCtrl = new TextEditingController();
  final List _questionDisplay = List<String>();
  final Survey _newSurvey = Survey();
  String _newQuestion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Health Check'),
          backgroundColor: Colors.teal,
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  height: 50,
                  alignment: Alignment.center,
                  child: Center(
                    child: TextFormField(
                      validator: (String val) {
                        return val.isEmpty ? AppLocalizations.of(context).translate('You need a Survey Name') : null;
                      },
                      decoration: new InputDecoration(hintText: AppLocalizations.of(context).translate('Survey Name')),
                      onChanged: (val) {
                        _newSurvey.setName(val);
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: (new ListView.builder(
                        itemCount: _questionDisplay.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return new Text(_questionDisplay[index]);
                        }))),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  height: 50,
                  alignment: Alignment.center,
                  child: Center(
                    child: TextFormField(
                      controller: eCtrl,
                      validator: (String val) {
                        return val.isEmpty ? AppLocalizations.of(context).translate('You need a question') : null;
                      },
                      decoration: new InputDecoration(hintText: AppLocalizations.of(context).translate('Question')),
                      onChanged: (val) {
                        _newQuestion = val;
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _questionDisplay.add(_newQuestion);
                    _newSurvey.addQuestion(_newQuestion);
                    eCtrl.clear();
                    setState(() {});
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 48,
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context).translate('Add question'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold))),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    //_newSurvey.setId(saveSurvey(_newSurvey));
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SurveyPage()));
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 48,
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context).translate('Create'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold))),
                ),
                SizedBox(height: 50),
              ],
            )));
  }
}
