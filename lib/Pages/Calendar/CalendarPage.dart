// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0
import 'dart:async';
import 'package:casia/BrainAnswer/ba_api.dart';
import 'package:casia/Pages/Calendar/calendar_info.dart';
import 'package:casia/Pages/Calendar/seizure_dialog.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/Utils/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:casia/Utils/appBar.dart';
import 'package:intl/intl.dart';

import 'calendar_utils.dart';

class TableCalendarPage extends StatefulWidget {
  @override
  _TableCalendarPageState createState() => _TableCalendarPageState();
}

class _TableCalendarPageState extends State<TableCalendarPage> {
  CalendarInfo calendarInfo = CalendarInfo();

  int currentYear = DateTime.now().year;
  String uid = BAApi.loginToken;

  ValueNotifier<List<Event>> _monthEvents = ValueNotifier([]);

  final DateTime kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final DateTime kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);
  DateTime startMonth;
  DateTime endMonth;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      calendarInfo.selectedDay = calendarInfo.focusedDay;
      calendarInfo.selectedEvents = _getEventsForDay(calendarInfo.selectedDay);
    });
  }

  @override
  void dispose() {
    calendarInfo.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime date;
    List<Event> events = [];

    for (var i = 0; i < _monthEvents.value.length; i++) {
      date = _monthEvents.value[i].date;
      if (DateTime(date.year, date.month, date.day) ==
          DateTime(day.year, day.month, day.day)) {
        events.add(_monthEvents.value[i]);
      }
    }
    //calendarInfo.selectedEvents = events;
    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(calendarInfo.selectedDay, selectedDay)) {
      calendarInfo.selectedDay = selectedDay;
      calendarInfo.focusedDay = focusedDay;

      calendarInfo.selectedEvents = _getEventsForDay(selectedDay);
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    calendarInfo.focusedDay = focusedDay;
    calendarInfo.selectedEvents = [];
    calendarInfo.selectedDay = focusedDay;
    calendarInfo.selectedMonth = focusedDay.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        AppBarHome(
          //context: context,
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
            child: PropertyChangeProvider(
              value: calendarInfo,
              child: PropertyChangeConsumer<CalendarInfo>(
                  properties: ['selectedMonth', 'calendarFormat'],
                  builder:
                      (BuildContext context, CalendarInfo calendarInfo, _) {
                    print('change in selectedMonth');
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('seizures')
                            .doc(uid)
                            .collection('events')
                            .where('Date',
                                isGreaterThan: Timestamp.fromDate(DateTime(
                                    currentYear, calendarInfo.selectedMonth)))
                            .where('Date',
                                isLessThan: Timestamp.fromDate(DateTime(
                                    currentYear,
                                    calendarInfo.selectedMonth + 1)))
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> eventSnapshot) {
                          if (eventSnapshot.hasData) {
                            _monthEvents.value = eventSnapshot.data.docs
                                .map((seizure) => Event.fromJson(seizure))
                                .toList();
                            print(_monthEvents.value);
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  PropertyChangeConsumer<CalendarInfo>(
                                      properties: ['selectedEvents'],
                                      builder: (BuildContext context,
                                          CalendarInfo calendarInfo, _) {
                                        return TableCalendar<Event>(
                                          firstDay: kFirstDay,
                                          lastDay: kLastDay,
                                          focusedDay: calendarInfo.focusedDay,
                                          selectedDayPredicate: (day) =>
                                              isSameDay(
                                                  calendarInfo.selectedDay,
                                                  day),
                                          calendarFormat:
                                              calendarInfo.calendarFormat,
                                          rangeSelectionMode:
                                              calendarInfo.rangeSelectionMode,
                                          eventLoader: _getEventsForDay,
                                          onDaySelected: _onDaySelected,
                                          onRangeSelected:
                                              (start, end, focusedDay) {},
                                          onFormatChanged: (format) {
                                            if (calendarInfo.calendarFormat !=
                                                format) {
                                              calendarInfo.calendarFormat =
                                                  format;
                                            }
                                          },
                                          onDayLongPressed: (start, end) {},
                                          onPageChanged: _onPageChanged,
                                          startingDayOfWeek:
                                              StartingDayOfWeek.monday,
                                          daysOfWeekHeight: 20.0,
                                          daysOfWeekStyle: DaysOfWeekStyle(
                                            dowTextFormatter: (date, locale) =>
                                                DateFormat.E('pt_PT')
                                                    .format(date)
                                                    .substring(0, 3),
                                          ),
                                          locale: 'pt_PT',
                                          calendarStyle: CalendarStyle(
                                              canMarkersOverflow: true,
                                              outsideDaysVisible: false),
                                          headerStyle: HeaderStyle(
                                            titleCentered: true,
                                            formatButtonDecoration:
                                                BoxDecoration(
                                              color: Color.fromRGBO(
                                                  102, 215, 209, 1),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            formatButtonTextStyle:
                                                TextStyle(color: Colors.white),
                                            formatButtonShowsNext: false,
                                          ),
                                          availableCalendarFormats: {
                                            CalendarFormat.month:
                                                AppLocalizations.of(context)
                                                    .translate('month'),
                                            CalendarFormat.twoWeeks: '2 ' +
                                                AppLocalizations.of(context)
                                                    .translate('weeks'),
                                            CalendarFormat.week:
                                                AppLocalizations.of(context)
                                                    .translate('week'),
                                          },
                                        );
                                      }),
                                  Expanded(
                                    child: PropertyChangeConsumer<CalendarInfo>(
                                        properties: ['selectedEvents'],
                                        builder: (BuildContext context,
                                            CalendarInfo calendarInfo, _) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: calendarInfo
                                                .selectedEvents.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 4.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: ListTile(
                                                  onTap: () => print(
                                                      '${calendarInfo.selectedEvents[index]}'),
                                                  title: Text(
                                                      '${calendarInfo.selectedEvents[index]}'),
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                  ),
                                  SizedBox(height: 52),
                                ]);
                          } else {
                            return Container();
                          }
                        });
                  }),
            ),
          ),
        ),
      ]),
    );
  }
}

class SeizureCalendar extends StatelessWidget {
  const SeizureCalendar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
