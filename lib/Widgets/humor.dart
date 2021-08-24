import 'package:casia/Database/database.dart';
import 'package:flutter/material.dart';
import '../app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/my_flutter_app_icons.dart';

class Humor {
  String _uid;
  List _fields;
  //DatabaseReference _id;
  Humor(this._fields);

  /* DatabaseReference getId() {
    return this._id;
  } */

  void setUid() {
    this._uid = 'humor_' +
        DateTime.now().day.toString() +
        '_' +
        DateTime.now().month.toString() +
        '_' +
        DateTime.now().year.toString();
  }

  void setFields(List<String> list) {
    this._fields = list;
  }

  String getUid() {
    return this._uid;
  }

  Humor.fromJson(Map<String, dynamic> json) {
    this._fields[0] = json['level'];
    this._fields[1] = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    return {'level': this._fields[0], 'timestamp': this._fields[1]};
  }
}

List<List<String>> getFields(record) {
  Map<String, dynamic> attributes = {
    'Humor': '',
    'Date': '',
    'Answer List': [],
  };
  record.forEach((key, value) => {attributes[key] = value});

  List<String> _answers = [];

  for (var i = 0; i < attributes['Answer List'].length; i++) {
    _answers.add(attributes['Answer List'][i].toString());
  }
  List<List<String>> _list = [
    [
      attributes['Humor'],
      attributes['Date'],
    ],
    _answers
  ];

  return _list;
}

class HumorDetails {
  List<String> values;
  String _humorId;

  HumorDetails();

  void setAnswers(List<String> answers) {
    this.values = answers;
  }

  void setHumorId(String id) {
    this._humorId = id;
  }

  String getHumorId() {
    return this._humorId;
  }

  Map<String, dynamic> toJson() {
    return {
      'Values': this.values,
    };
  }

  HumorDetails.fromJson(Map<String, dynamic> json) {
    this.values = json['Values'];
  }
}

Widget humorQuestion(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(left: 20),
    child: Text(
      'How are you feeling?',
      style: TextStyle(
          fontFamily: 'canter', color: DefaultColors.purpleLogo, fontSize: 50),
    ),
  );
}

Widget pillQuestion(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(left: 20, top: 20),
    child: Text(
      'Missed any medication' + '?',
      style: TextStyle(
          fontFamily: 'canter', color: DefaultColors.purpleLogo, fontSize: 50),
    ),
  );
}

Widget newhumor(BuildContext context) {
  return //Card(
      //elevation: 0,
      //child:
      DecoratedBox(
          decoration: BoxDecoration(
              color: DefaultColors.boxHome,
              borderRadius: BorderRadius.circular(10)),
          child: Column(children: <Widget>[
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    saveHumor('Angry', DateTime.now());
                    //homelist.remove(0);
                  },
                  child: Icon(MyFlutterApp.storm,
                      size: 40, color: DefaultColors.backgroundColor),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    //homelist_.remove(0);
                    saveHumor('Sad', DateTime.now());
                    //homelist.remove(0);
                  },
                  child: Icon(MyFlutterApp.cloudy,
                      size: 40, color: DefaultColors.backgroundColor),
                ),
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    saveHumor('Happy', DateTime.now());
                    //homelist.remove(0);
                  },
                  child: Icon(MyFlutterApp.sunny_day,
                      size: 40, color: DefaultColors.backgroundColor),
                ),
              ),
            ]),
            SizedBox(height: 10),
            Text(AppLocalizations.of(context).translate("Mood"),
                style: Theme.of(context).textTheme.bodyText1),
            SizedBox(height: 10),
          ]));
}

Widget filledhumor(BuildContext context, humorLevel) {
  IconData iconHumor;
  if (humorLevel == 'Sad') {
    iconHumor = MyFlutterApp.cloudy;
  } else if (humorLevel == 'Happy') {
    iconHumor = MyFlutterApp.sunny_day;
  } else {
    iconHumor = MyFlutterApp.storm;
  }
  return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: DefaultColors.boxHome,
      child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: DefaultColors.boxHomePurple,
          ),
          //gradient: LinearGradient(colors: [
          // DefaultColors.alarmColor,
          //DefaultColors.boxHome,
          //DefaultColors.boxHome,
          //])),
          child: Column(children: <Widget>[
            //Spacer(flex: 1),
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: Icon(iconHumor,
                  size: 60, color: DefaultColors.backgroundColor),
            ),
            SizedBox(height: 10),
            Text(AppLocalizations.of(context).translate("Today's mood"),
                style: Theme.of(context).textTheme.bodyText1),
            SizedBox(height: 10),
          ])));
}
