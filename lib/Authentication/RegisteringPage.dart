import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Models/patient.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';

//for the dictionaries
import '../app_localizations.dart';

class RegisteringPage extends StatefulWidget {
  RegisteringPage({Key key}) : super(key: key);

  @override
  _RegisteringPageState createState() => _RegisteringPageState();
}

class _RegisteringPageState extends State<RegisteringPage> {
  List<String> _userDetails = List(7);
  String gender;
  List<bool> _secondaryEffects = [false, false, false, false, false, false];
  final _formKey = GlobalKey<FormState>();
  String uid = FirebaseAuth.instance.currentUser.uid;

  String dropdownValueType;
  String dropdownValueMedication;

  bool _unchecked1 = false;
  bool _unchecked2 = false;
  bool _unchecked3 = false;
  bool _unchecked4 = false;
  bool _unchecked5 = false;
  bool _unchecked6 = false;
  List<String> symptoms;

  @override
  void initState() {
    super.initState();
    gender = AppLocalizations.of(context).translate('None');
    dropdownValueType = AppLocalizations.of(context).translate('Unselected');
    dropdownValueMedication = AppLocalizations.of(context).translate('None');
    symptoms = [
      AppLocalizations.of(context).translate('Diziness'),
      AppLocalizations.of(context).translate('Headaches'),
      AppLocalizations.of(context).translate('Irritability'),
      AppLocalizations.of(context).translate('Mood changes'),
      AppLocalizations.of(context).translate('Skipping Menstrual Cycle'),
      AppLocalizations.of(context).translate('Somnolence')
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitle(context, 'Register'),
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
                      Text(AppLocalizations.of(context).translate('Sex')),
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
                        Text(AppLocalizations.of(context).translate('Male')),
                      ]),
                      Row(children: [
                        SizedBox(
                          width: 10,
                          child: Radio(
                            value: 'Female',
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
                        Text(AppLocalizations.of(context).translate('Female')),
                      ]),
                    ]),

                    // NAME
                    TextFormField(
                      validator: (String val) {
                        return val.isEmpty
                            ? AppLocalizations.of(context)
                                .translate('Must be filled.')
                            : null;
                      },
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context).translate('Name'),
                      ),
                      onSaved: (String value) {
                        _userDetails[0] = value;
                      },
                    ),

                    // AGE
                    TextFormField(
                      validator: (String val) {
                        return val.isEmpty
                            ? AppLocalizations.of(context)
                                .translate('Must be filled.')
                            : null;
                      },
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context).translate('Age'),
                      ),
                      onSaved: (String value) {
                        _userDetails[1] = value;
                      },
                    ),

                    // SEIZURE FREQUENCY
                    TextFormField(
                      validator: (String val) {
                        return val.isEmpty
                            ? AppLocalizations.of(context)
                                .translate('Must be filled.')
                            : null;
                      },
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('Seizure Frequency'),
                        hintText: AppLocalizations.of(context)
                            .translate('(e.g. once a week)'),
                      ),
                      onSaved: (String value) {
                        _userDetails[3] = value;
                      },
                    ),

                    // COMMON TYPE OF SEIZURE
                    Row(
                      children: [
                        Text(AppLocalizations.of(context)
                                .translate("Most common type of seizure") +
                            ":"),
                        DropdownButton<String>(
                          value: dropdownValueType,
                          elevation: 16,
                          style: TextStyle(color: Colors.teal),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValueType = newValue;
                            });
                            _userDetails[4] = newValue;
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

                    // MEDICATION USED
                    Row(children: [
                      Text(AppLocalizations.of(context)
                              .translate("Medication prescription") +
                          ":"),
                      DropdownButton<String>(
                        value: dropdownValueMedication,
                        elevation: 16,
                        style: TextStyle(color: Colors.teal),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValueMedication = newValue;
                          });
                          _userDetails[5] = newValue;
                        },
                        items: <String>[
                          AppLocalizations.of(context).translate('None'),
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
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('Other medication'),
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
                      Text(AppLocalizations.of(context)
                              .translate("Most common secondary effects") +
                          ":"),
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
                        AppLocalizations.of(context).translate('Finish'),
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
