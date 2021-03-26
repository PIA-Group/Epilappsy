import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epilappsy/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Database/seizures.dart';
import 'package:epilappsy/Pages/EventsPage.dart';
import 'package:epilappsy/Pages/SeizureLog.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:table_calendar/table_calendar.dart';

class SeizureDiary extends StatefulWidget {
  @override
  _SeizureDiaryState createState() => _SeizureDiaryState();
}

class _SeizureDiaryState extends State<SeizureDiary> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  Map<DateTime, List<dynamic>> _holidays;
  List<dynamic> _selectedEvents;
  int _i;
  List<List<List<String>>> _seizures = [];
  String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
    _i = 0;
  }

  Map<DateTime, List<dynamic>> _seizuresToEvents(
      List<List<List<String>>> allSeizures) {
    Map<DateTime, List<dynamic>> data = {};
    for (var i = 0; i < allSeizures.length; i++) {
      DateTime date = DateFormat.yMd().parse(allSeizures[i][0][0]);
      print('yMd: $date');
      if (data[date] == null) data[date] = [];
      data[date].add(allSeizures[i]);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarAll(
          context,
          [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                pushNewScreen(
                  context,
                  screen: SeizureLog(
                    duration: '',
                  ),
                  withNavBar: true,
                );
              },
            )
          ],
          'Calendar'),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('seizures')
              .doc(uid)
              .collection('events')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (_i == 0) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  snapshot.data.docs.forEach((doc) => {
                        print(doc.data()),
                        _seizures.add(getDetails(doc.data()))
                      });
                  print('list seizures: $_seizures');
                }
                if (_seizures.isNotEmpty) {
                  _events = _seizuresToEvents(_seizures);
                  print('events: $_events');
                } else {
                  _events = {};
                  _selectedEvents = [];
                }
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
                            color: Colors.white)),
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
                  ..._selectedEvents.map((event) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        color: Color.fromRGBO(149, 214, 56, 1),
                        child: ListTile(
                          title: Text(
                            event[0][1],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            print('event: $event');
                            pushNewScreen(context,
                                screen: EventsPage(seizure: event));
                          },
                        ),
                      )),
                ],
              ),
            );
          }),
    );
  }
}
