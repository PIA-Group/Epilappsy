import 'package:epilappsy/Database/reminders.dart';
import 'package:epilappsy/Pages/Medication/MedicationPage.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/Pages/Medication/LocalNotifications.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NewMedicationEntry extends StatefulWidget {
  
  final ReminderDetails answers; 

  NewMedicationEntry({Key key, this.answers}) : super(key: key);

  @override
  _NewMedicationEntryState createState() => _NewMedicationEntryState();
}

class _NewMedicationEntryState extends State<NewMedicationEntry> {
  
  final _formKey = GlobalKey<FormState>();
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
  int _interval = 0;
  User currentUser;
  FirebaseFirestore firestore;
  String uid;
  DocumentSnapshot reminder;
  List<String> details = new List(11);
  List<Map<String, String>> visibilityRules = [];

  
  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    firestore = FirebaseFirestore.instance;
    uid = FirebaseAuth.instance.currentUser.uid;
    //answers.addListener(() =>
        //updateReminderWidgetList()); // listens to changes in the user's answers
    super.initState();
  }

  
  Future<List<Widget>> initReminderWidgetList(ValueNotifier<Map> answers) async {
    // initiate list of widgets [Widget, Widget, ...] according to the info on firestore
    String surveyID = await firestore
        .collection('medication-reminders')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print("default reminder ID: ${documentSnapshot.data()['default survey']}");
      return documentSnapshot.data()['default survey'];
    });
  }

  var isSelected=[false,false,false,false];
  
  void _updateTime(TimeOfDay time) {
    _time = time;
  }
  
  void _updateInterval(int interval) {
    _interval = interval;
  }
  
  

  @override
  Widget build(BuildContext context) {
    //reference to the firebase reminders list -  Provider.of....(context) ?;
    return Scaffold(
      backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              title: appBarTitle(context, 'Add new reminder'),
              backgroundColor: Theme.of(context).unselectedWidgetColor,
              ),
      body: Center(
        child: Column(
          children: <Widget>[
              FieldTitle(
                title: "Medicine Name",
                isRequired: true,
              ),
              TextFormField(
                maxLength: 12,
                style: TextStyle(
                  fontSize: 16,
                ),
                onSaved: (String value) {
                  details[0] = value; }
              ),
              FieldTitle(
                title: "Dosage in mg",
                isRequired: false,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 16,
                ),
                textCapitalization: TextCapitalization.words,
                onSaved: (String value) {
                  details[1] = value; }
              ),
              SizedBox(
                height: 15,
              ),
              FieldTitle(
                title: "Medicine Type",
                isRequired: false,
              ),
              ToggleButtons(
                selectedBorderColor: DefaultColors.accentColor,
                borderWidth: 2.0,
                selectedColor: DefaultColors.accentColor,
                children: <Widget>[
                  ImageIcon(AssetImage("assets/pill.png"), size:50),
                  ImageIcon(AssetImage("assets/syrup.png"), size:50),
                  ImageIcon(AssetImage("assets/syringe.png"), size:50),
                  ImageIcon(AssetImage("assets/cream.png"), size:50),
                ],
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = true;
                        //details[2] = buttonIndex as String;
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
                isSelected: isSelected,
                
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                color: Colors.black
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),           
              FieldTitle(
                title: "Select the interval between doses",
                isRequired: true,
              ),
              IntervalSelection(
                onIntervalSelected: _updateInterval),
              Divider(
                color: Colors.black
              ),
              FieldTitle(
                title: "Starting Time",
                isRequired: true,
              ),
              SelectTime(onTimeSelected: _updateTime),
              Divider(
                color: Colors.black
              ),
              SizedBox(
                height: 15,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  primary: DefaultColors.mainColor,
                  backgroundColor: DefaultColors.mainColor,
                  side: BorderSide(width: 2, color: DefaultColors.mainColor),
                ), 
                child: Text("Confirm", 
                  style: TextStyle(
                    color: DefaultColors.textColorOnDark,
                    fontSize: 19,
                    fontWeight: FontWeight.w500)),
                onPressed: () {
                  details[3] = _interval as String;
                  details[4] = _time as String;
                 
                  DateTime time = DateTime(0,0,0,_time.hour,_time.minute,0,0,0);

                  double maxRepeats = 24/_interval;
                  for(int repeats = 0 ; repeats < maxRepeats; repeats++) {
                    LocalNotifications().addReminder(time);
                    print( "${time.hour.toString()}:${time.minute.toString()}:${time.second.toString()}");
                    
                    time = time.add(Duration(hours: _interval));

                    
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      saveReminder(Reminder(
                        FirebaseAuth.instance.currentUser.uid,
                        details,
                        widget.answers));
                      pushNewScreen(context, screen: MedicationPage());
                  
                    } 
                  }

                  
                            
                }
              
              ),
              ],
        ),
      ),
    );}}


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
            style: TextStyle(fontSize: 14, color: DefaultColors.accentColor),
          ),
        ]),
      ),
    );
  }
}


// CLASS TO SELECT THE STARTING TIME FOR TO TAKE THE MEDICATION
class SelectTime extends StatefulWidget {
  SelectTime({@required this.onTimeSelected});
  final Function onTimeSelected;
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  bool _clicked = false;
  TimeOfDay _time;
  Future<TimeOfDay> _selectTime() async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _time ?? TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });
    if (picked != null && picked != _time) {
      widget.onTimeSelected(picked);
      setState(() {
        _clicked = true;
        _time = picked;
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
                  primary: DefaultColors.mainColor,
                  side: BorderSide(width: 2, color: DefaultColors.mainColor),
                ), 
                onPressed: () {
                  _selectTime();
                },
                child: Center(
                  child: Text(
                    _clicked == false
                        ? "Pick time to start"
                        : "${_time.hour.toString()}:${_time.minute.toString()}",
                    style: TextStyle(
                      color: DefaultColors.mainColor,
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

// CLASS TO SELECT THE INTERVAL BETWEEN MEDICATIONS
class IntervalSelection extends StatefulWidget {
  IntervalSelection({@required this.onIntervalSelected});
  final Function onIntervalSelected;
  @override
  _IntervalSelectionState createState() => _IntervalSelectionState();
}
class _IntervalSelectionState extends State<IntervalSelection> {
  final List<int> _intervals = const [
    6,
    8,
    12,
    24,
  ];

  int _selected;

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
                color: DefaultColors.textColorOnLight,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButton<int>(
              iconEnabledColor: DefaultColors.mainColor,
              hint: _selected == 0
                  ? Text(
                      "Select an Interval",
                      style: TextStyle(
                          fontSize: 10,
                          color: DefaultColors.textColorOnLight,
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
                      color: DefaultColors.mainColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                widget.onIntervalSelected(newVal);
                setState(() {
                  _selected = newVal;
                });
              },
            ),
            Text(
              _selected == 1 ? " hour" : " hours",
              style: TextStyle(
                color: DefaultColors.textColorOnLight,
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



