import 'package:casia/Database/database.dart';
import 'package:casia/design/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:casia/Database/seizures.dart';
import 'package:casia/Pages/AddSeizure/NewSeizureTransitionPage.dart';
import 'package:casia/Pages/EventsPage.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:casia/Pages/Calendar/seizure_dialog.dart';

class SeizureDiary extends StatefulWidget {
  SeizureDiary();
  //final String loginToken;

  @override
  _SeizureDiaryState createState() => _SeizureDiaryState();
}

class _SeizureDiaryState extends State<SeizureDiary> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  //Map<DateTime, List<dynamic>> _holidays;
  List<dynamic> _selectedEvents;
  int _i;
  List<int> _idx;
  List<List<dynamic>> _seizures;
  List<List<String>> _keys;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
    _seizures = [];
    _keys = [];
    _idx = [];
    _i = 0;
  }

  Map<DateTime, List<dynamic>> _seizuresToEvents(
      List<List<dynamic>> allSeizures) {
    Map<DateTime, List<dynamic>> data = {};
    DateTime date;
    for (var i = 0; i < allSeizures.length; i++) {
      for (var k = 0; k < allSeizures[i].length; k++) {
        if (allSeizures[i][k].toString().contains('Timestamp')) {
          date = allSeizures[i][k].toDate();
        }
      }
      if (data[date] == null) data[date] = [];
      data[date].add(allSeizures[i]);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarAll(context, [], 'Calendar'),
      body: FutureBuilder<dynamic>(
          future: getMonthlySeizures(_controller.focusedDay.month),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                _seizures = [];
                _keys = [];
                print(_seizures);
                snapshot.data.docs.forEach((doc) => {
                      print(doc.data()),
                      _seizures.add(getDetails(doc.data())),
                      _keys.add(getKeys(doc.data()))
                    });
                print('list seizures: $_seizures');
              }
              if (_seizures.isNotEmpty) {
                _events = _seizuresToEvents(_seizures);
                print('events: $_events');
                print(_keys);
              } else {
                _events = {};
                _selectedEvents = [];
              }
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TableCalendar(
                    events: _events,
                    initialCalendarFormat: CalendarFormat.month,
                    calendarStyle: CalendarStyle(
                        canEventMarkersOverflow: true,
                        todayColor: Colors.yellowAccent,
                        selectedColor: Color.fromRGBO(149, 214, 56, 1),
                        todayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black)),
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      formatButtonDecoration: BoxDecoration(
                        color: Color.fromRGBO(102, 215, 209, 1),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      formatButtonTextStyle: TextStyle(color: Colors.white),
                      formatButtonShowsNext: false,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: (date, events, holidays) {
                      setState(() {
                        _selectedEvents = events;
                        _i = 1;
                      });
                    },
                    builders: CalendarBuilders(
                      selectedDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(149, 214, 56, 1),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                      todayDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(102, 215, 209, 1),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    calendarController: _controller,
                  ),
                  ..._selectedEvents.map(
                    (event) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                      color: DefaultColors.boxHomePurple,
                      child: ListTile(
                          title: Text(
                            event[_keys[_i].indexOf('Type')],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SeizureInfoDialog(
                                      seizure: event,
                                      keys: _keys[
                                          _selectedEvents.indexOf(event)]);
                                });
                          }),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
