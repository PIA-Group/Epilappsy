import 'dart:math';
import 'package:flutter/material.dart';
import 'package:epilappsy/Medication/convert_time.dart';
import 'package:epilappsy/Medication/MedicationPage.dart';
import 'package:epilappsy/Medication/errors.dart';
import 'package:epilappsy/Medication/medicine.dart';
import 'package:epilappsy/Medication/medicine_type.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:epilappsy/Widgets/appBar.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:epilappsy/app_localizations.dart';


class NewReminder extends StatefulWidget {
  @override
  _NewReminderState createState() => _NewReminderState();
}

class _NewReminderState extends State<NewReminder> {

  List<String> _medicationDetails = List(7);
  final _formKey = GlobalKey<FormState>();
  String medication_type;
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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

                    // MEDICINE NAME
                    FieldTitle(
                      title: 'Medicine Name:',
                      isRequired: true,
                    ),
                    TextFormField(
                      validator: (String val) {
                        return val.isEmpty ? 'Must be filled.' : null;
                      },
                      style: TextStyle(fontSize: 13),
                      onSaved: (String value) {
                        _medicationDetails[0] = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),



                    // DOSAGE
                    FieldTitle(
                      title: "Dosage (mg):",
                      isRequired: false,
                    ),
                    TextFormField(
                      validator: (String val) {
                        return val.isEmpty ? 'Must be filled.' : null;
                      },
                      style: TextStyle(fontSize: 13),
                      keyboardType: TextInputType.number,
                      onSaved: (String value) {
                        _medicationDetails[1] = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),

                   

                    // MEDICINE TYPE
                    FieldTitle(
                      title: "Medication type",
                      isRequired: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => setState(() => _value = 0),
                          child: Container(
                            height: 56,
                            width: 56,
                            color: _value == 0 ? Colors.grey : Colors.transparent,
                            child: Icon(Icons.call), //use 'assets/pills.png'
                          ),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => setState(() => _value = 1),
                          child: Container(
                            height: 56,
                            width: 56,
                            color: _value == 1 ? Colors.grey : Colors.transparent,
                            child: Icon(Icons.message), //use 'assets/bottle.png'
                          ),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => setState(() => _value = 1),
                          child: Container(
                            height: 56,
                            width: 56,
                            color: _value == 1 ? Colors.grey : Colors.transparent,
                            child: Icon(Icons.message), //use 'assets/syringe.png'
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),



                    
                    // TIME INTERVAL
                    FieldTitle(
                      title: "Interval between medication",
                      isRequired: true,
                    ),
                    IntervalSelection(),
                    SizedBox(
                      height: 25,
                    ),
                    


                    // STARTING TIME
                    FieldTitle(
                      title: "Starting Time",
                      isRequired: true,
                    ),
                    SelectTime(),
                    SizedBox(
                      height: 30,
                    ),



                    // SUBMIT BUTTON
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * 0.08,
                        right: MediaQuery.of(context).size.height * 0.08,
                      ),
                      child: Container(
                        width: 220,
                        height: 70,
                        child: FlatButton(
                          color: Color.fromRGBO(71, 123, 117, 1),
                          shape: RoundedRectangleBorder(),
                          child: Center(
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                        onPressed: () {

                        },
                        )))]
                     
        
    )))]))));  }
}


class FieldTitle extends StatelessWidget {
  final String title;
  final bool isRequired;
  FieldTitle({
    Key key,
    @required this.title,
    @required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 4),
      child: Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
            text: title,
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: isRequired ? " *" : "",
            style: TextStyle(fontSize: 14, color: Color.fromRGBO(71, 123, 117, 1)),
          ),
        ]),
      ),
    );
  }
}




class IntervalSelection extends StatefulWidget {
  @override
  _IntervalSelectionState createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  var _intervals = [
    6,
    8,
    12,
    24,
  ];
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Remind me every  ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButton<int>(
              iconEnabledColor: Color.fromRGBO(71, 123, 117, 1),
              hint: _selected == 0
                  ? Text(
                      "Select an Interval",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    )
                  : null,
              elevation: 4,
              value: _selected == 0 ? null : _selected,
              items: _intervals.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _selected = newVal;
                  //_newEntryBloc.updateInterval(newVal);
                });
              },
            ),
            Text(
              _selected == 1 ? " hour" : " hours",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectTime extends StatefulWidget {
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay> _selectTime(BuildContext context) async {
   
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
        //_newEntryBloc.updateTime("${convertTime(_time.hour.toString())}" + "${convertTime(_time.minute.toString())}");
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 4),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(),
            side: BorderSide(width: 2, color: Color.fromRGBO(71, 123, 117, 1)),
          ),          
          onPressed: () {
            _selectTime(context);
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? "Pick Time"
                  : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
              style: TextStyle(
                color: Color.fromRGBO(71, 123, 117, 1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
