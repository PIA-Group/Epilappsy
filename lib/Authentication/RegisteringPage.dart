import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Models/patient.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/main.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class RegisteringPage extends StatefulWidget {
  RegisteringPage({Key key}) : super(key: key);

  @override
  _RegisteringPageState createState() => _RegisteringPageState();
}

class _RegisteringPageState extends State<RegisteringPage> {
  List<String> _userDetails = List(7);
  String gender = 'None';
  List<bool> _secondaryEffects = [false, false, false, false, false, false];
  final _formKey = GlobalKey<FormState>();
  String uid = FirebaseAuth.instance.currentUser.uid;

  String dropdownValue_type = 'Unselected';
  String dropdownValue_medication = 'None';

  bool _unchecked1 = false;
  bool _unchecked2 = false;
  bool _unchecked3 = false;
  bool _unchecked4 = false;
  bool _unchecked5 = false;
  bool _unchecked6 = false;
  List<String> symptoms = [
    'Diziness',
    'Headaches',
    'Irritability',
    'Mood changes',
    'Skipping Menstrual Cycle',
    'Somnolence'
  ];

  @override
  Widget build(BuildContext context) {
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
                    // SEX
                    Row(children: [
                      Text('Sex:    '),
                      Row(children: [
                        SizedBox(
                          width: 10,
                          child: Radio(
                            value: 'male',
                            groupValue: gender,
                            activeColor: Colors.teal,
                            onChanged: (value) {
                              //value may be true or false
                              setState(() {
                                gender = value;
                              });
                              _userDetails[2] = value;
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text('Male     ')
                      ]),
                      Row(children: [
                        SizedBox(
                          width: 10,
                          child: Radio(
                            value: 'Female   ',
                            groupValue: gender,
                            activeColor: Colors.teal,
                            onChanged: (value) {
                              //value may be true or false
                              setState(() {
                                gender = value;
                              });
                              _userDetails[2] = value;
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text('Female')
                      ]),
                    ]),

                    // NAME
                    TextFormField(
                      validator: (String val) {
                        return val.isEmpty ? 'You need to set a time' : null;
                      },
                      style: TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      onSaved: (String value) {
                        _userDetails[0] = value;
                      },
                    ),

                    // AGE
                    TextFormField(
                      validator: (String val) {
                        return val.isEmpty ? 'You need to set a time' : null;
                      },
                      style: TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Age',
                      ),
                      onSaved: (String value) {
                        _userDetails[1] = value;
                      },
                    ),

                    // SEIZURE FREQUENCY
                    TextFormField(
                      validator: (String val) {
                        return val.isEmpty ? 'You need to set a time' : null;
                      },
                      style: TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Seizure Frequency',
                        hintText: '(e.g. once a week)',
                      ),
                      onSaved: (String value) {
                        _userDetails[3] = value;
                      },
                    ),

                    // COMMON TYPE OF SEIZURE
                    Row(
                      children: [
                        Text("Most common type of seizure:   "),
                        DropdownButton<String>(
                          value: dropdownValue_type,
                          elevation: 16,
                          style: TextStyle(color: Colors.teal),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue_type = newValue;
                            });
                            _userDetails[4] = newValue;
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

                    // MEDICATION USED
                    Row(children: [
                      Text("Medication prescription:   "),
                      DropdownButton<String>(
                        value: dropdownValue_medication,
                        elevation: 16,
                        style: TextStyle(color: Colors.teal),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue_medication = newValue;
                          });
                          _userDetails[5] = newValue;
                        },
                        items: <String>[
                          'None',
                          'Brivaracetam',
                          'Lorazepam',
                          'Diazepam',
                          'Depakote',
                          'Depakene'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]),

                    TextFormField(
                      style: TextStyle(fontSize: 10),
                      decoration: const InputDecoration(
                        labelText: 'Other medication',
                      ),
                      onSaved: (String value) {
                        _userDetails[6] = value;
                      },
                    ),

                    Text(''),
                    Text(''),
                    Text(''),

                    // COMMON MEDICATION SYMPTOMS
                    Row(children: [
                      Text("Most common secondary effects:   "),
                    ]),
                    Column(
                      children: [
                        CheckboxListTile(
                            title: Text(symptoms.elementAt(0)),
                            value: _unchecked1,
                            onChanged: (bool value) {
                              setState(() {
                                _unchecked1 = value;
                              });
                              _secondaryEffects[0] = value;
                            }),
                        CheckboxListTile(
                            title: Text(symptoms.elementAt(1)),
                            value: _unchecked2,
                            onChanged: (bool value) {
                              setState(() {
                                _unchecked2 = value;
                              });
                              _secondaryEffects[1] = value;
                            }),
                        CheckboxListTile(
                            title: Text(symptoms.elementAt(2)),
                            value: _unchecked3,
                            onChanged: (bool value) {
                              setState(() {
                                _unchecked3 = value;
                              });
                              _secondaryEffects[2] = value;
                            }),
                        CheckboxListTile(
                            title: Text(symptoms.elementAt(3)),
                            value: _unchecked4,
                            onChanged: (bool value) {
                              setState(() {
                                _unchecked4 = value;
                              });
                              _secondaryEffects[3] = value;
                            }),
                        CheckboxListTile(
                            title: Text(symptoms.elementAt(4)),
                            value: _unchecked5,
                            onChanged: (bool value) {
                              setState(() {
                                _unchecked5 = value;
                              });
                              _secondaryEffects[4] = value;
                            }),
                        CheckboxListTile(
                            title: Text(symptoms.elementAt(5)),
                            value: _unchecked6,
                            onChanged: (bool value) {
                              setState(() {
                                _unchecked6 = value;
                              });
                              _secondaryEffects[5] = value;
                            }),
                      ],
                    ),

                    Text(""),

                    //SUBMISSION BUTTON
                    RaisedButton(
                      child: Text(
                        'Finish',
                        style: TextStyle(color: Colors.teal, fontSize: 16),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          final Patient _newUser = Patient();
                          _newUser.setUserDetails(_userDetails);
                          _newUser.setUserSideEffects(_secondaryEffects);
                          savePatient(uid, _newUser);
                          Navigator.pop(context);
                          //pushNewScreen(context, screen: MyApp());
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ]),
        )));
  }
}
