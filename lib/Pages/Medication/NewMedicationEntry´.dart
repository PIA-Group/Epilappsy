import 'package:epilappsy/main.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/Pages/Medication/LocalNotifications.dart';

//for the dictionaries
import '../../app_localizations.dart';

class NewMedicationEntry extends StatefulWidget {
  
  @override
  _NewMedicationEntryState createState() => _NewMedicationEntryState();
}

class _NewMedicationEntryState extends State<NewMedicationEntry> {

  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
  int _interval = 0;

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
              title: appBarTitle(context),
              backgroundColor: Theme.of(context).unselectedWidgetColor,
              ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}"),
            IntervalSelection(onIntervalSelected: _updateInterval),
            SelectTime(onTimeSelected: _updateTime),
            OutlinedButton(
              child: new Text("Save reminder",
                  style: TextStyle(fontSize: 20.0, color: Colors.black)),
              onPressed: () {
                
                DateTime time = DateTime(0,0,0,_time.hour,_time.minute,0,0,0);


                double maxRepeats = 24/_interval;
                for(int repeats = 0 ; repeats < maxRepeats; repeats++) {
                  LocalNotifications().addReminder(time);
                  print( "${time.hour.toString()}:${time.minute.toString()}:${time.second.toString()}");
                  
                  time = time.add(Duration(hours: _interval));
                }
                print("Saved!");
              },
            ),
          ],
        ),
      ),
    );}}




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
            side: BorderSide(width: 1, color: Color.fromRGBO(71, 123, 117, 1)),
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
                widget.onIntervalSelected(newVal);
                setState(() {
                  _selected = newVal;
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
