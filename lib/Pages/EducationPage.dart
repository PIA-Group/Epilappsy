import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';

class EducationalPage extends StatefulWidget {
  EducationalPage({Key key}) : super(key: key);

  @override
  _EducationalPageState createState() => _EducationalPageState();
}

class _EducationalPageState extends State<EducationalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitle(context),
          backgroundColor: Color.fromRGBO(71, 123, 117, 1),
        ),
        body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 20,
                          height: 50,),
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context).translate('What is Epilepsy?'),
                              style: new TextStyle(fontSize: 12.0),
                              textAlign: TextAlign.justify,)
                              ),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 15.0,
                              ),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 20,
                          height: 50,),
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context).translate(
                            'What is a seizure?'),
                            style: new TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.justify,
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 20,
                          height: 50,),
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context).translate(
                            'Types of seizures?'),
                            style: new TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.justify,
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 20,
                          height: 50,),
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context).translate(
                            'Possible trigers?'),
                            style: new TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.justify,
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 20,
                          height: 50,),
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context).translate(
                            'Treating Seizures'),
                            style: new TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.justify,
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 20,
                          height: 50,),
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context).translate(
                            'Managing Epilepsy'),
                            style: new TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.justify,
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 20,
                          height: 50,),
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context).translate(
                            'What is SUDEP?'),
                            style: new TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.justify,
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 20,
                          height: 50,),
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(AppLocalizations.of(context).translate(
                            'Challenges in Epilepsy'),
                            style: new TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.justify,
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
        ]));
  }
}

