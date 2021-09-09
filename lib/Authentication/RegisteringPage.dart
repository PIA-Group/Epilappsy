import 'package:casia/Models/patient.dart';
import 'package:casia/Utils/appBar.dart';
import 'package:flutter/material.dart';
import 'package:casia/main.dart';

//for the dictionaries
import '../Utils/app_localizations.dart';

class RegisteringPage extends StatefulWidget {
  @override
  _RegisteringPageState createState() => _RegisteringPageState();
}

class _RegisteringPageState extends State<RegisteringPage> {
  List<String> _userDetails = List.filled(7, '');
  String gender;
  List<bool> _secondaryEffects = [false, false, false, false, false, false];
  final _formKey = GlobalKey<FormState>();

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
      AppLocalizations.of(context).translate('diziness'.inCaps),
      AppLocalizations.of(context).translate('headaches'.inCaps),
      AppLocalizations.of(context).translate('irritability'.inCaps),
      AppLocalizations.of(context).translate('mood changes'.inCaps),
      AppLocalizations.of(context)
          .translate('skipping menstrual cycle'.capitalizeFirstofEach),
      AppLocalizations.of(context).translate('somnolence'.inCaps)
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
                      Text(
                          AppLocalizations.of(context).translate('sex'.inCaps)),
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
                        Text(AppLocalizations.of(context)
                            .translate('male'.inCaps)),
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
                        Text(AppLocalizations.of(context)
                            .translate('female'.inCaps)),
                      ]),
                    ]),

                    // NAME
                    TextFormField(
                      validator: (String val) {
                        return val.isEmpty
                            ? AppLocalizations.of(context)
                                    .translate('must be filled'.inCaps) +
                                '.'
                            : null;
                      },
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('name'.inCaps),
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
                                    .translate('must be filled'.inCaps) +
                                '.'
                            : null;
                      },
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('age'.inCaps),
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
                                    .translate('must be filled'.inCaps) +
                                '.'
                            : null;
                      },
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).translate(
                            'seizure frequency'.capitalizeFirstofEach),
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
                        Text(AppLocalizations.of(context).translate(
                                "most common type of seizure".inCaps) +
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
                            AppLocalizations.of(context).translate('unselected'.inCaps),
                            AppLocalizations.of(context).translate('absence'.inCaps),
                            AppLocalizations.of(context).translate('atonic'.inCaps),
                            AppLocalizations.of(context).translate('clonic'.inCaps),
                            AppLocalizations.of(context).translate('myoclonic'.inCaps),
                            AppLocalizations.of(context).translate('tonic'.inCaps),
                            AppLocalizations.of(context).translate('tonic clonic'.capitalizeFirstofEach)
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
                              .translate("medication prescription".inCaps)+":"),
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
                           AppLocalizations.of(context).translate('none'.inCaps),
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
                            .translate('other medication'.inCaps),
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
                              .translate("most common secondary effects".inCaps)+":"),
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
                    ElevatedButton(
                      child: Text(
                        AppLocalizations.of(context).translate('finish'.inCaps),
                        style: TextStyle(color: Colors.teal, fontSize: 16),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          final Patient _newUser = Patient();
                          _newUser.setUserDetails(_userDetails);
                          _newUser.setUserSideEffects(_secondaryEffects);
                          // savePatient(widget.loginToken, _newUser);
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
