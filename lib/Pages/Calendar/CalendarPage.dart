// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'package:casia/Pages/Calendar/seizure_dialog.dart';
import 'package:casia/Database/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:casia/Widgets/appBar.dart';

import 'calendar_utils.dart';

class TableCalendarPage extends StatefulWidget {
  @override
  _TableCalendarPageState createState() => _TableCalendarPageState();
}

class _TableCalendarPageState extends State<TableCalendarPage> {
  final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier(null);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;
  dynamic allSeizures;
  List<Event> list_seizures;
  final kToday = DateTime.now();
  dynamic _seizures;

  @override
  void initState() {
    super.initState();

    final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
    list_seizures = [];
    _selectedDay = _focusedDay;
    _selectedEvents.value = list_seizures;
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime date;
    List<Event> events = [];
    for (var i = 0; i < list_seizures.length; i++) {
      date = list_seizures[i].date;
      if (DateTime(date.year, date.month, date.day) ==
          DateTime(day.year, day.month, day.day)) {
        events.add(list_seizures[i]);
      }
      ;
    }

    return events;
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<Event> _getSeizuresInRange(data) {
    List<Event> seizures = [];
    data.forEach((value) {
      if (value != null) {
        seizures.add(Event(value['Type'], value['Date'].toDate()));
      }
    });
    print(seizures);
    return seizures;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(_selectedDay);
    }
  }

  void _onRangeSelected(DateTime start, DateTime end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarAll(context, [], 'Calendar'),
      body: FutureBuilder<dynamic>(
          future: getSeizuresInRange(_rangeStart, _rangeEnd),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                list_seizures = _getSeizuresInRange(snapshot.data);
                print('HERE');
              }
              if (list_seizures.isNotEmpty) {
                print('List Seizures $list_seizures');
              } else {
                list_seizures = [];
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TableCalendar<Event>(
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  daysOfWeekHeight: 20.0,
                  calendarStyle: CalendarStyle(
                      canMarkersOverflow: true, outsideDaysVisible: false),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonDecoration: BoxDecoration(
                      color: Color.fromRGBO(102, 215, 209, 1),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    formatButtonTextStyle: TextStyle(color: Colors.white),
                    formatButtonShowsNext: false,
                  ),
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                    print(_focusedDay);
                  },
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Update month'),
                    onTap: () {
                      print('It is suppose to refresh seizures');
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                                title: Text('${value[index]}'),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SeizureInfoDialog(
                                            date: value[0].date);
                                      });
                                }),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
