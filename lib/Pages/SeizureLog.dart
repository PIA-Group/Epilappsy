import 'dart:io';
import 'package:epilappsy/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Database/seizures.dart';
import 'package:epilappsy/Pages/SeizureDiaryPage.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

//for the dictionaries
import '../app_localizations.dart';

class SeizureLog extends StatefulWidget {
  final String duration;
  final Answers answers;
  SeizureLog({Key key, this.duration, this.answers}) : super(key: key);

  @override
  _SeizureLogState createState() => _SeizureLogState();
}

class _SeizureLogState extends State<SeizureLog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController timeCtl = TextEditingController();
  String dropdownValueType;
  String dropdownValueMood;
  String dropdownValueTriggers;
  String dropdownValueDescription;
  String dropdownValuePostevents;

  List<String> details = new List(11);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      dropdownValueType = AppLocalizations.of(context).translate('Unselected');
      dropdownValueMood = AppLocalizations.of(context).translate('Unselected');
      dropdownValueTriggers =
          AppLocalizations.of(context).translate('Unselected');
      dropdownValueDescription =
          AppLocalizations.of(context).translate('Unselected');
      dropdownValuePostevents =
          AppLocalizations.of(context).translate('Unselected');
    });
  }

  @override
  Widget build(BuildContext context) {
    File imageFile;
    _openGallery() async {
      // ignore: deprecated_member_use
      var picture = await ImagePicker.pickVideo(source: ImageSource.gallery);
      this.setState(() {
        imageFile = picture;
      });
    }

    return Scaffold(
        appBar: appBarAll(
            context,
            [
              IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
            'New Seizure'),
        drawer: Drawer(),
        body: SingleChildScrollView(
            child: Center(
          child: Column(children: [
            Container(
              margin: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // DATE
                    InputDatePickerFormField(
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 30)),
                      lastDate: DateTime.now().add(Duration(days: 30)),
                      onDateSaved: (value) {
                        details[0] = '${DateFormat('yMd').format(value)}';
                      },
                    ),
                    // TIME
                    TextFormField(
                      validator: (String val) {
                        return val.isEmpty
                            ? AppLocalizations.of(context)
                                .translate('You need to set a time')
                            : null;
                      },
                      controller: timeCtl,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        TimeOfDay picked = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.input,
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        timeCtl.text = picked.format(context);
                      },
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context).translate('Time'),
                        hintText: AppLocalizations.of(context)
                            .translate('(e.g. hh:mm am or hh:mm pm)'),
                      ),
                      onSaved: (String value) {
                        details[1] = value;
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                    ),

                    // SEIZURE LENGTH
                    TextFormField(
                      validator: (String val) {
                        return val.isEmpty
                            ? AppLocalizations.of(context)
                                .translate('You need to set a duration.')
                            : null;
                      },
                      initialValue: widget.duration,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('Seizure Duration'),
                        hintText: AppLocalizations.of(context)
                            .translate('(e.g. mm:ss)'),
                      ),
                      onChanged: (String value) {
                        details[2] = value;
                      },
                    ),
                    // SEIZURE TYPE
                    Row(
                      children: [
                        Text(AppLocalizations.of(context)
                            .translate("Seizure Type:")),
                        DropdownButton<String>(
                          value: dropdownValueType,
                          elevation: 16,
                          style: TextStyle(color: Colors.teal),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValueType = newValue;
                            });
                            details[3] = newValue;
                          },
                          items: <String>[
                            AppLocalizations.of(context)
                                .translate('Unselected'),
                            AppLocalizations.of(context).translate('Absence'),
                            AppLocalizations.of(context).translate('Atonic'),
                            AppLocalizations.of(context).translate('Clonic'),
                            AppLocalizations.of(context).translate('Myoclonic'),
                            AppLocalizations.of(context).translate('Tonic'),
                            AppLocalizations.of(context)
                                .translate('Tonic Clonic')
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    // MOOD
                    Row(children: [
                      Text(AppLocalizations.of(context).translate("Mood:")),
                      DropdownButton<String>(
                        value: dropdownValueMood,
                        elevation: 16,
                        style: TextStyle(color: Colors.teal),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValueMood = newValue;
                          });
                          details[4] = newValue;
                        },
                        items: <String>[
                          AppLocalizations.of(context).translate('Unselected'),
                          AppLocalizations.of(context).translate('Normal'),
                          AppLocalizations.of(context).translate('Good'),
                          AppLocalizations.of(context).translate('Bad')
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]),

                    // POSSIBLE TRIGGERS
                    Row(children: [
                      Text(AppLocalizations.of(context)
                          .translate("Possible Triggers:")),
                      DropdownButton<String>(
                        value: dropdownValueTriggers,
                        elevation: 16,
                        style: TextStyle(color: Colors.teal),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValueTriggers = newValue;
                          });
                          details[5] = newValue;
                        },
                        items: <String>[
                          AppLocalizations.of(context).translate('Unselected'),
                          AppLocalizations.of(context)
                              .translate('Changes in Medication'),
                          AppLocalizations.of(context)
                              .translate('Overtired or irregular sleep'),
                          AppLocalizations.of(context)
                              .translate('Irregular Diet'),
                          AppLocalizations.of(context)
                              .translate('Alcohol or Drug Abuse'),
                          AppLocalizations.of(context)
                              .translate('Bright or flashing lights'),
                          AppLocalizations.of(context)
                              .translate('Emotional Stress'),
                          AppLocalizations.of(context)
                              .translate('Fever or Overheated'),
                          AppLocalizations.of(context)
                              .translate('Hormonal Fluctuations'),
                          AppLocalizations.of(context).translate('Sick'),
                          AppLocalizations.of(context).translate('Other')
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]),

                    // TRIGGERS NOTES
                    TextFormField(
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('Triggers Notes'),
                      ),
                      onChanged: (String value) {
                        details[6] = value ??
                            AppLocalizations.of(context)
                                .translate('Not filled');
                      },
                    ),

                    // DESCRIPTIONS
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Expanded(
                          child: Text(AppLocalizations.of(context)
                              .translate("Description:"))),
                      Expanded(
                        flex: -1,
                        child: DropdownButton<String>(
                          value: dropdownValueDescription,
                          elevation: 16,
                          style: TextStyle(color: Colors.teal),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValueDescription = newValue;
                              details[7] = newValue;
                            });
                          },
                          items: <String>[
                            AppLocalizations.of(context)
                                .translate('Unselected'),
                            AppLocalizations.of(context)
                                .translate('Had an aura'),
                            AppLocalizations.of(context)
                                .translate('Loss of urine or bowel control'),
                            AppLocalizations.of(context)
                                .translate('Changes in awareness'),
                            AppLocalizations.of(context)
                                .translate('Automatic Repeated Movements'),
                            AppLocalizations.of(context)
                                .translate('Loss of Ability to communicate'),
                            AppLocalizations.of(context)
                                .translate('Muscle Stiffness'),
                            AppLocalizations.of(context)
                                .translate('Muscle twitch'),
                            AppLocalizations.of(context)
                                .translate('Loss of consciousness'),
                            AppLocalizations.of(context).translate('Other')
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ]),

                    // DESCRIPTION NOTES
                    TextFormField(
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('Description Notes'),
                      ),
                      onChanged: (String value) {
                        details[8] = value ??
                            AppLocalizations.of(context)
                                .translate('Not filled');
                      },
                    ),

                    // POST EVENTS
                    Row(children: [
                      Text(AppLocalizations.of(context)
                          .translate("Post Events:")),
                      DropdownButton<String>(
                        value: dropdownValuePostevents,
                        elevation: 16,
                        style: TextStyle(color: Colors.teal),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValuePostevents = newValue;
                          });
                          details[9] = newValue;
                        },
                        items: <String>[
                          AppLocalizations.of(context).translate('Unselected'),
                          AppLocalizations.of(context)
                              .translate('Unnable to communicate'),
                          AppLocalizations.of(context)
                              .translate('Remembers event'),
                          AppLocalizations.of(context)
                              .translate('Muscle weakness'),
                          AppLocalizations.of(context).translate('Sleepy'),
                          AppLocalizations.of(context).translate('Other')
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]),

                    // POST EVENTS NOTES
                    TextFormField(
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('Post Events Notes'),
                      ),
                      onChanged: (String value) {
                        details[10] = value ??
                            AppLocalizations.of(context)
                                .translate('Not filled');
                      },
                    ),

                    Text(''),
                    Text(''),
                    // ADD VIDEO
                    Text(AppLocalizations.of(context)
                        .translate("Add video recording (optional)")),
                    IconButton(
                      onPressed: () {
                        _openGallery();
                      },
                      icon: Icon(
                        Icons.videocam,
                      ),
                      iconSize: 20.0,
                      color: Colors.black87,
                    ),

                    //SUBMISSION BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                          child: Text(
                            AppLocalizations.of(context).translate('Submit'),
                            style: TextStyle(color: Colors.teal, fontSize: 16),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              saveSeizure(Seizure(
                                  FirebaseAuth.instance.currentUser.uid,
                                  details,
                                  widget.answers));
                              pushNewScreen(context, screen: SeizureDiary());
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ]),
        )));
  }
}
