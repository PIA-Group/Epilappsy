import 'dart:io';
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
  String dropdownValue_type = 'Unselected';
  String dropdownValue_mood = 'Unselected';
  String dropdownValue_triggers = 'Unselected';
  String dropdownValue_description = 'Unselected';
  String dropdownValue_postevents = 'Unselected';
  List<String> details = new List(11);

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
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitle(context),
          backgroundColor: Color.fromRGBO(71, 123, 117, 1),
        ),
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
                        return val.isEmpty ? 'You need to set a time' : null;
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
                      decoration: const InputDecoration(
                        labelText: 'Time',
                        hintText: '(e.g. hh:mm am or hh:mm pm)',
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
                            ? 'You need to set a duration.'
                            : null;
                      },
                      initialValue: widget.duration,
                      style: TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Seizure Duration',
                        hintText: '(e.g. mm:ss)',
                      ),
                      onChanged: (String value) {
                        details[2] = value;
                      },
                    ),
                    // SEIZURE TYPE
                    Row(
                      children: [
                        Text("Seizure Type:   "),
                        DropdownButton<String>(
                          value: dropdownValue_type,
                          elevation: 16,
                          style: TextStyle(color: Colors.teal),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue_type = newValue;
                            });
                            details[3] = newValue;
                          },
                          items: <String>[
                            'Unselected',
                            'Absence',
                            'Atonic',
                            'Clonic',
                            'Myoclonic',
                            'Tonic',
                            'Tonic Clonic'
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
                      Text("Mood:   "),
                      DropdownButton<String>(
                        value: dropdownValue_mood,
                        elevation: 16,
                        style: TextStyle(color: Colors.teal),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue_mood = newValue;
                          });
                          details[4] = newValue;
                        },
                        items: <String>['Unselected', 'Normal', 'Good', 'Bad']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]),

                    // POSSIBLE TRIGGERS
                    Row(children: [
                      Text("Possible Triggers:   "),
                      DropdownButton<String>(
                        value: dropdownValue_triggers,
                        elevation: 16,
                        style: TextStyle(color: Colors.teal),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue_triggers = newValue;
                          });
                          details[5] = newValue;
                        },
                        items: <String>[
                          'Unselected',
                          'Changes in Medication',
                          'Overtired or irregular sleep',
                          'Irregular Diet',
                          'Alcohol or Drug Abuse',
                          'Bright or flashing lights',
                          'Emotional Stress',
                          'Fever or Overheated',
                          'Hormonal Fluctuations',
                          'Sick',
                          'Other'
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
                      decoration: const InputDecoration(
                        labelText: 'Triggers Notes',
                      ),
                      onChanged: (String value) {
                        details[6] = value ?? 'Not filled';
                      },
                    ),

                    // DESCRIPTIONS
                    Row(children: [
                      Text("Description:   "),
                      DropdownButton<String>(
                        value: dropdownValue_description,
                        elevation: 16,
                        style: TextStyle(color: Colors.teal),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue_description = newValue;
                          });
                          details[7] = newValue;
                        },
                        items: <String>[
                          'Unselected',
                          'Had an aura',
                          'Loss of urine or bowel control',
                          'Changes in awareness',
                          'Automatic Repeated Movements',
                          'Loss of Ability to communicate',
                          'Muscle Stiffness',
                          'Muscle twitch',
                          'Loss of consciousness',
                          'Other'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]),

                    // DESCRIPTION NOTES
                    TextFormField(
                      style: TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Description Notes',
                      ),
                      onChanged: (String value) {
                        details[8] = value ?? 'Not filled';
                      },
                    ),

                    // POST EVENTS
                    Row(children: [
                      Text("Post Events:   "),
                      DropdownButton<String>(
                        value: dropdownValue_postevents,
                        elevation: 16,
                        style: TextStyle(color: Colors.teal),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue_postevents = newValue;
                          });
                          details[9] = newValue;
                        },
                        items: <String>[
                          'Unselected',
                          'Unnable to communicate',
                          'Remembers event',
                          'Muscle weakness',
                          'Sleepy',
                          'Other'
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
                      decoration: const InputDecoration(
                        labelText: 'Post Events Notes',
                      ),
                      onChanged: (String value) {
                        details[10] = value ?? 'Not filled';
                      },
                    ),

                    Text(''),
                    Text(''),
                    // ADD VIDEO
                    Text("Add video recording (optional)"),
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
                            'Submit',
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
