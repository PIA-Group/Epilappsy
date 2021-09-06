// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
import 'dart:async';
import 'package:casia/Pages/Calendar/seizure_dialog.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:intl/intl.dart';

import 'calendar_utils.dart';

class TableCalendarPage extends StatefulWidget {
  @override
  _TableCalendarPageState createState() => _TableCalendarPageState();
}

class _TableCalendarPageState extends State<TableCalendarPage> {
  ValueNotifier<List<Event>> _selectedEvents = ValueNotifier(null);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;
  dynamic allSeizures;
  List<Event> listSeizures;
  final kToday = DateTime.now();
  final DateTime kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final DateTime kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);
  StreamController<List<Event>> _events;
  DateTime startMonth;
  DateTime endMonth;

  @override
  void initState() {
    super.initState();
    listSeizures = [];
    _selectedDay = _focusedDay;
    _selectedEvents.value = listSeizures;
    _events = new StreamController<List<Event>>();
    _updateSeizures(kToday);
    ;
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime date;
    List<Event> events = [];
    for (var i = 0; i < _selectedEvents.value.length; i++) {
      date = _selectedEvents.value[i].date;
      if (DateTime(date.year, date.month, date.day) ==
          DateTime(day.year, day.month, day.day)) {
        events.add(_selectedEvents.value[i]);
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
    if (data != null) {
      data.forEach((value) {
        if (value != null) {
          seizures.add(Event(value['Type'], value['Date'].toDate()));
        }
      });
    }
    ;
    print('Inside $seizures');
    _events = new StreamController<List<Event>>();
    _events.add(seizures);
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

  void _updateSeizures(DateTime focusDay) {
    startMonth = DateTime(focusDay.year, focusDay.month, 1);
    endMonth = DateTime(focusDay.year, focusDay.month + 1, 1);
    _events = StreamController<List<Event>>();

    getSeizuresInRange(startMonth, endMonth).then(
        (value) => _selectedEvents = ValueNotifier(_getSeizuresInRange(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        AppBarAll(
          context: context,
          titleH: 'calendar',
        ),
        Positioned(
          top: AppBarAll.appBarHeight,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                color: DefaultColors.backgroundColor,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0),
                )),
            child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return StreamBuilder(
                      stream: _events.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            print('Events ${snapshot.data}');
                            print(_focusedDay);
                            _updateSeizures(_focusedDay);
                          } else {
                            print("I'm Empty");
                          }
                        }
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              TableCalendar<Event>(
                                daysOfWeekStyle: DaysOfWeekStyle(
                                  dowTextFormatter: (date, locale) =>
                                      DateFormat.E('pt_PT')
                                          .format(date)
                                          .substring(0, 3),
                                ),
                                locale: 'pt_PT',
                                firstDay: kFirstDay,
                                lastDay: kLastDay,
                                focusedDay: _focusedDay,
                                selectedDayPredicate: (day) =>
                                    isSameDay(_selectedDay, day),
                                rangeStartDay: _rangeStart,
                                rangeEndDay: _rangeEnd,
                                calendarFormat: _calendarFormat,
                                rangeSelectionMode: _rangeSelectionMode,
                                eventLoader: _getEventsForDay,
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                daysOfWeekHeight: 20.0,
                                calendarStyle: CalendarStyle(
                                    canMarkersOverflow: true,
                                    outsideDaysVisible: false),
                                headerStyle: HeaderStyle(
                                  titleCentered: true,
                                  formatButtonDecoration: BoxDecoration(
                                    color: Color.fromRGBO(102, 215, 209, 1),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  formatButtonTextStyle:
                                      TextStyle(color: Colors.white),
                                  formatButtonShowsNext: false,
                                ),
                                onDaySelected: _onDaySelected,
                                onRangeSelected: _onRangeSelected,
                                onFormatChanged: (format) {
                                  if (_calendarFormat != format) {
                                    setState(() {
                                      _calendarFormat = format;
                                      _updateSeizures(_focusedDay);
                                    });
                                  }
                                },
                                onPageChanged: (focusedDay) {
                                  _focusedDay = focusedDay;
                                  _updateSeizures(_focusedDay);
                                  _selectedEvents.notifyListeners();
                                },
                              ),
                              //const SizedBox(height: 8.0),
                              Expanded(
                                  child: ListView.builder(
                                scrollDirection: Axis.vertical,
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
                              ))
                            ]);
                      });
                }),
          ),
        ),
      ]),
    );
  }
}
