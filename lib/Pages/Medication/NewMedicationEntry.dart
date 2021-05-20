import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Pages/Medication/medications.dart';
import 'package:epilappsy/Pages/Medication/reminders.dart';
import 'package:epilappsy/Pages/Medication/MedicationPage.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/Pages/Medication/LocalNotifications.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class NewMedicationEntry extends StatefulWidget {
  final ReminderDetails rem_details;
  final MedicationDetails med_details;
  final Answers answers;

  NewMedicationEntry({Key key, this.rem_details,this.med_details,this.answers}) : super(key: key);

  @override
  _NewMedicationEntryState createState() => _NewMedicationEntryState();
}

class _NewMedicationEntryState extends State<NewMedicationEntry> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  Map<String, dynamic> formData;
  bool spontaneous = false;
  bool _alarm = true;
  List<String> medication_names = [ /*LIST ALL MEDICATIONS ON FIRESTORE*/];
  final dosage = TextEditingController();
  String _mode = "Take with food";
  String dropdownValue = 'mg';
  DateTime start_date = DateTime.now();
  int _interval = 0;
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);  
  List <TimeOfDay> alarm_times;
  String valueChoose;
  List dosagetype =['mg', 'ml', 'pills'];

  User currentUser;
  FirebaseFirestore firestore;
  String uid;
  DocumentSnapshot reminder;
  List<Map<String, String>> visibilityRules = [];
  List med_details = [];
  List rem_details = [];

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    firestore = FirebaseFirestore.instance;
    uid = FirebaseAuth.instance.currentUser.uid;
    //answers.addListener(() =>
    //updateReminderWidgetList()); // listens to changes in the user's answers
    super.initState();
  }

/*
  Future<List<Widget>> initReminderWidgetList(
      ValueNotifier<Map> answers) async {
    // initiate list of widgets [Widget, Widget, ...] according to the info on firestore
    String surveyID = await firestore
        .collection('medication-patients')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print(
          "default reminder ID: ${documentSnapshot.data()['default survey']}");
      return documentSnapshot.data()['default survey'];
    });
  }*/

  var isSelected = [false, false, false, false];

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
        title: appBarTitle(context, 'Add new medication'),
        backgroundColor: Theme.of(context).unselectedWidgetColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            
            // TOMA ESPONTÂNEA
            CheckboxListTile(
              title: Text('Toma espontânea'),
              value: spontaneous, 
              onChanged: (bool newValue) {
                setState(() {
                  spontaneous = newValue;
                });
                if (spontaneous) {
                  _alarm = false;
                }
              } 
              ),
              

            // MEDICINE NAME
            FieldTitle(
              title: "Medicine Name",
              isRequired: true,
            ),
            Row(children: [
              Container(width: 30), 
              Container(
                width: 330,
                child: TextFormField(
              maxLength: 12,
              style: TextStyle(
                fontSize: 16,
              ),
              controller: name,
            ),
              )]),


            // MEDICINE TYPE
            FieldTitle(
              title: "Medicine Type",
              isRequired: true,
            ),
            ToggleButtons(
              selectedBorderColor: DefaultColors.accentColor,
              borderWidth: 2.0,
              selectedColor: DefaultColors.accentColor,
              children: <Widget>[
                ImageIcon(AssetImage("assets/pill.png"), size: 50),
                ImageIcon(AssetImage("assets/syrup.png"), size: 50),
                ImageIcon(AssetImage("assets/syringe.png"), size: 50),
                ImageIcon(AssetImage("assets/cream.png"), size: 50),
              ],
              onPressed: (int index) {
                List<String> types = ['Pill','Syrup','Syringe','Lotion'];
                setState(() {
                  for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                  rem_details[1] = types[index];
                  med_details[1] = types[index];
                });
              },
              isSelected: isSelected,
            ),
            SizedBox(
              height: 18,
            ),


            // DOSAGE
            FieldTitle(
              title: "Dosage",
              isRequired: true,
            ),
            Row(children: [
              Container(width: 40),
              Container(
                width: 200,
                child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 16,
                ),
                textCapitalization: TextCapitalization.words,
                controller: dosage,
              ),),
              Container(
                width: 90,
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  border: Border.all( width: 1),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: DropdownButton(
                  hint: Text(dosagetype[0]),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 16,
                  isExpanded: true,
                  underline: SizedBox(),
                  value: valueChoose,
                  onChanged: (newValue) {
                    setState(() {
                      valueChoose = newValue;
                    });
                  },
                  items: dosagetype.map((valueItem) {
                    return DropdownMenuItem(
                      child: Text(valueItem),
                      value: valueItem,);
                  }).toList(),
                  ),)
              ]),
                                    
            SizedBox(
              height: 18,
            ),
            


            // TAKE WITH OR WITHOUT FOOD
            
              ListTile(
                title: const Text("Take with food"),
                leading: Radio<String>(
                  value: "Take with food",
                  groupValue: _mode,
                  onChanged: (String value) {
                    setState(() {
                      _mode = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("Take on empty stomach"),
                leading: Radio<String>(
                  value: "Take on empty stomach",
                  groupValue: _mode,
                  onChanged: (String value) {
                    setState(() {
                      _mode = value;
                    });
                  },
                ),
              ),
            

            SizedBox(
              height: 18,
            ),

            Column(
              children: <Widget>[
                if (!spontaneous)
                
                Column(
                  children: <Widget>[
                    // DATA INÍCIO DA TOMA
                    FieldTitle(
                      title: "Início da toma",
                      isRequired: false,
                    ),
                    
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select date'),
                    ),
                    
                    SizedBox(
                      height: 18,
                    ),])
                  ]),


            // ACTIVATE/DEACTIVATE REMINDERS
            Row(
              children: <Widget>[
                Container(width: 30),
                Text("Activate reminders for this medication          "),
                FlutterSwitch(
                  width: 60.0,
                  height: 30.0,
                  valueFontSize: 12.0,
                  toggleSize: 19.0,
                  value: _alarm,
                  padding: 8.0,
                  showOnOff: true,
                  onToggle: (val) {
                    setState(() {
                     _alarm = val;
                     rem_details[6] = _alarm;
                    });
                  },
                )],
            ),


            Column(
              children: <Widget>[
                if (_alarm) 

                  Column(
                  children: <Widget>[
                  
                  SizedBox(
                    height: 18,
                  ),

                  // PICK INTERVAL
                  FieldTitle(
                    title: "Select the interval between doses",
                    isRequired: true,
                  ),
                  IntervalSelection(onIntervalSelected: _updateInterval),


                  // PICK START TIME
                  FieldTitle(
                    title: "Starting Time",
                    isRequired: true,
                  ),
                  SelectTime(onTimeSelected: _updateTime),

                  SizedBox(
                    height: 18,
                  ),
                ]),
                ]),

            
            OutlinedButton(
              
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  primary: DefaultColors.mainColor,
                  backgroundColor: DefaultColors.mainColor,
                  alignment: Alignment.bottomCenter,
                ),
                child: Text("Confirm",
                    style: TextStyle(
                        color: DefaultColors.textColorOnDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                onPressed: () {
                  rem_details[0] = name.text;
                  rem_details[2] = dosage.text;
                  rem_details[3] = _mode;
                  rem_details[4] = spontaneous;                  
                  rem_details[7] = _interval.toString();

                  med_details[0] = name.text;
                  med_details[2] = dosage.text;
                  med_details[3] = _mode;
                  med_details[4] = spontaneous;
                  med_details[6] = _interval.toString();
                                    

                  DateTime time =
                      DateTime(0, 0, 0, _time.hour, _time.minute, 0, 0, 0);

                  double maxRepeats = 24 / _interval;
                  for (int repeats = 0; repeats < maxRepeats; repeats++) {

                    rem_details[8] = [rem_details[8],"${time.hour.toString()}:${time.minute.toString()}:${time.second.toString()}"];
                    LocalNotifications().addReminder(time);
                    print(
                        "${time.hour.toString()}:${time.minute.toString()}:${time.second.toString()}");

                    time = time.add(Duration(hours: _interval));
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save(); 
                      saveMedication(Medication(
                        FirebaseAuth.instance.currentUser.uid,
                         med_details,
                         widget.med_details));
                      saveReminder(Reminder(
                        FirebaseAuth.instance.currentUser.uid,
                        rem_details,
                        widget.rem_details));
                      
                      pushNewScreen(context, screen: MedicationPage());
                    }
                  }
                } 
               ),
          ],
        ),
      ),
    ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: start_date,
        firstDate: DateTime(start_date.year-100),
        lastDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendar,
        locale: Locale('pt','PT'));
        
    if (picked != null && picked != start_date)
      setState(() {
        start_date = picked;
        med_details[5] = "${start_date.year.toString()}:${start_date.month.toString()}:${start_date.day.toString()}";
        rem_details[5] = "${start_date.year.toString()}:${start_date.month.toString()}:${start_date.day.toString()}";;
      });
  }
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
        initialEntryMode: TimePickerEntryMode.input,
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
