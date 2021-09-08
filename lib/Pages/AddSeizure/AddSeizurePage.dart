import 'package:casia/Database/seizures.dart';
import 'package:casia/Utils/costum_dialogs/time_day_dialog.dart';
import 'package:casia/design/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:casia/BrainAnswer/ba_api.dart';
import 'package:casia/BrainAnswer/form_data.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/Utils/costum_dialogs/checkbox_dialog.dart';
import 'package:casia/Utils/costum_dialogs/date_dialog.dart';
import 'package:casia/Utils/costum_dialogs/duration_dialog.dart';
import 'package:casia/Utils/appBar.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';


class BAAddSeizurePage extends StatefulWidget {
  ValueNotifier<String> duration;
  ValueNotifier<String> time;
  ValueNotifier<String> location;
  ValueNotifier<IconData> periodOfDay;
  final Seizure seizure;
  final SeizureDetails seizureDetails;
  final List<FieldData> formFields;
  final String seizureName;

  BAAddSeizurePage({
    this.duration,
    this.time,
    this.periodOfDay,
    this.seizure,
    this.seizureDetails,
    this.formFields,
    this.seizureName,
  });

  @override
  _BAAddSeizurePageState createState() => _BAAddSeizurePageState();
}

class _BAAddSeizurePageState extends State<BAAddSeizurePage> {
  ValueNotifier<List<DateTime>> datePicker;
  ValueNotifier<int> timeOfSeizureIndex;
  Seizure seizure;

  ValueNotifier<List<dynamic>> answers;

  FirebaseFirestore firestore;
  DocumentSnapshot seizures;
  List seizureDetails = List.filled(7, null);

  @override
  void initState() {
    super.initState();

    answers = ValueNotifier(List.filled(widget.formFields.length, null));
    _initAnswers();

    datePicker = ValueNotifier(<DateTime>[DateTime.now()]);
    if (widget.duration == null) widget.duration = ValueNotifier('00:00:00.0');
    if (widget.time == null)
      widget.time = ValueNotifier(
          "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}");
    var hour = DateTime.now().hour;
    if ((hour > 5) && (hour <= 12)) {
      timeOfSeizureIndex = ValueNotifier(1);
    } else if ((hour > 12) && (hour <= 20)) {
      timeOfSeizureIndex = ValueNotifier(2);
    } else {
      timeOfSeizureIndex = ValueNotifier(3);
    }
  }

  void _initAnswers() {
    widget.formFields.asMap().forEach((i, fieldData) {
      if (!fieldData.hidden) {
        if (fieldData.type == 'checkbox') {
          setState(() =>
              answers.value[i] = List.filled(fieldData.options.length, false));
        } else if (fieldData.type == 'radio') {
          setState(() => answers.value[i] = false);
        }
      } else {
        if (fieldData.label == 'type')
          setState(() => answers.value[i] = widget.seizureName);
        else
          setState(() =>
              answers.value[i] = List.filled(fieldData.options.length, true));
      }
    });
    answers.notifyListeners();
  }

  Widget getQuestionnaireTile(FieldData fieldData, int i, List _answers) {
    if (fieldData.hidden && fieldData.label == 'type') {
      return ListTile(
        title: Text(
          fieldData.question,
          style: MyTextStyle(),
        ),
        subtitle: Text(widget.seizureName,
            style: MyTextStyle(color: Colors.grey[600], fontSize: 16)),
      );
    } else {
      if (fieldData.type == 'checkbox') {
        return ListTile(
            title: Text(
              fieldData.question,
              style: MyTextStyle(),
            ),
            subtitle: !answers.value[i].contains(true)
                ? Text(
                    AppLocalizations.of(context).translate('Click here to add'),
                    style: MyTextStyle(color: Colors.grey[600], fontSize: 16))
                : Text(getCheckboxAnswers(fieldData.options, answers.value[i]),
                    style: MyTextStyle(color: Colors.grey[600], fontSize: 16)),
            trailing: Icon(Icons.add_circle),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CheckboxDialog(
                      listOfCheckboxes: fieldData.options,
                      answers: answers,
                      index: i,
                      icon: Icons.bolt,
                      title: fieldData.question,
                    );
                  });
            });
      } else if (fieldData.type == 'radio') {
        //TODO
        if (!fieldData.horizontal) {
          return ListTile(
            title: Text(
              fieldData.question,
              style: MyTextStyle(),
            ),
            subtitle: Text(
                AppLocalizations.of(context).translate('Click here to choose'),
                style: MyTextStyle(color: Colors.grey[600], fontSize: 16)),
          );
        } else {
          return SwitchListTile(
            title: Text(
              fieldData.question,
              style: MyTextStyle(),
            ),
            value: answers.value[i],
            onChanged: (bool value) {
              setState(() => answers.value[i] = value);
            },
          );
        }
      } else if (fieldData.type == 'text') {
        return ListTile(
          title: Text(fieldData.question),
          subtitle: new Container(
            width: 150.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Expanded(
                  flex: 3,
                  child: new TextField(
                    style: MyTextStyle(color: Colors.grey[600], fontSize: 16),
                    decoration: new InputDecoration.collapsed(
                        hintText: AppLocalizations.of(context)
                            .translate('Type here')),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    }
  }

  String getCheckboxAnswers(List options, List answer) {
    List aux = answer.asMap().entries.map((e) {
      if (e.value == true) return options[e.key];
    }).toList();
    aux.removeWhere((value) => value == null);
    return aux.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: appBarAll(
        context,
        [],
        AppLocalizations.of(context).translate('New Seizure'),
      ),*/
      body: Stack(
        children: [
          AppBarAll(
            context: context,
            titleH: 'new seizure',
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
              child: ListView(children: [
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TimeDayDialog(
                                      time: widget.time,
                                      periodOfDay: widget.periodOfDay,
                                      icon: Icons.bolt,
                                      title: AppLocalizations.of(context)
                                          .translate('Time of seizure'),
                                    );
                                  });
                            },
                            child: Column(children: [
                              Icon(Icons.access_time_rounded,
                                  size: 30, color: DefaultColors.mainColor),
                              ValueListenableBuilder(
                                builder: (BuildContext context, String time,
                                    Widget child) {
                                  return Text(
                                    DateFormat("HH:mm").format(DateTime(
                                        0,
                                        0,
                                        0,
                                        int.parse(time.split(':')[0]),
                                        int.parse(time.split(':')[1]))),
                                    style: MyTextStyle(),
                                    textAlign: TextAlign.center,
                                  );
                                },
                                valueListenable: widget.time,
                              ),
                            ]),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DateDialog(
                                      datePicker: datePicker,
                                      icon: Icons.calendar_today_outlined,
                                      title: AppLocalizations.of(context)
                                          .translate('Date(s) of seizure(s)'),
                                    );
                                  });
                            },
                            child: Column(children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 30, color: DefaultColors.mainColor),
                              ValueListenableBuilder(
                                builder: (BuildContext context,
                                    List<DateTime> dates, Widget child) {
                                  return Text(
                                    dates.length == 1
                                        ? '${dates[0].day}-${dates[0].month}-${dates[0].year}'
                                        : '...',
                                    style: MyTextStyle(),
                                    textAlign: TextAlign.center,
                                  );
                                },
                                valueListenable: datePicker,
                              ),
                            ]),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DurationDialog(
                                      duration: widget.duration,
                                      icon: Icons.timer_rounded,
                                      title: AppLocalizations.of(context)
                                          .translate('Duration of seizure'),
                                    );
                                  });
                            },
                            child: Column(children: [
                              Icon(Icons.timer_rounded,
                                  size: 30, color: DefaultColors.mainColor),
                              ValueListenableBuilder(
                                builder: (BuildContext context, String time,
                                    Widget child) {
                                  return Text(
                                    "${time.split(':')[1]}:${time.split(':')[2].substring(0, time.split(':')[2].indexOf('.'))}",
                                    style: MyTextStyle(),
                                    textAlign: TextAlign.center,
                                  );
                                },
                                valueListenable: widget.duration,
                              ),
                            ]),
                          ),
                        ),
                      ]),
                ),
                SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(children: [
                            Icon(Icons.videocam_outlined,
                                size: 30, color: DefaultColors.mainColor),
                          ]),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(children: [
                            Icon(MdiIcons.microphoneOutline,
                                size: 30, color: DefaultColors.mainColor),
                          ]),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(children: [
                            Icon(Icons.add_location_outlined,
                                size: 30, color: DefaultColors.mainColor),
                          ]),
                        ),
                      ),
                    ]),
                SizedBox(height: 20),
                Divider(height: 0, thickness: 2, indent: 15, endIndent: 15),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ValueListenableBuilder(
                    builder:
                        (BuildContext context, List _answers, Widget child) {
                      print('rebuilt');
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, position) {
                          return getQuestionnaireTile(
                              widget.formFields[position], position, _answers);
                        },
                        itemCount: widget.formFields.length,
                      );
                    },
                    valueListenable: answers,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        primary: DefaultColors.mainColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        print('${widget.duration}');
                        print(widget.duration.toString());

                        List<DateTime> dates = datePicker.value;
                        List<Timestamp> _savedDates =
                            List<Timestamp>.filled(dates.length, null);
                        print('DATES: ');
                        for (int i = 0; i < dates.length; i++) {
                          print(
                              '${dates[i].day}-${dates[i].month}-${dates[i].year}');
                          _savedDates[i] = Timestamp.fromDate(DateTime(
                              dates[i].year, dates[i].month, dates[i].day));
                          // '${dates[i].day}-${dates[i].month}-${dates[i].year}';
                        }

                        print(answers.value[0]);
                        print(answers.value[1]);
                        print(answers.value[2]);
                        print(answers.value[3]);
                        print(answers.value[4]);
                        print(answers.value[5]);
                        print(answers.value[6]);

                        print('token: ${BAApi.loginToken}');
                        print(
                            'triggers: ${getCheckboxAnswers(widget.formFields[2].options, answers.value[2]).split(', ')}');

                        //TODO
                        for (int i = 0; i < _savedDates.length; i++) {
                          saveSeizure(Seizure(
                              BAApi.loginToken,
                              _savedDates[i], //time
                              widget.duration.value.toString(), //duration
                              widget.location.toString(), //location
                              answers.value[0].toString(), //type of seizure
                              getCheckboxAnswers(widget.formFields[1].options,
                                      answers.value[1])
                                  .split(', '), //auras
                              getCheckboxAnswers(widget.formFields[2].options,
                                      answers.value[2])
                                  .split(', '), //triggers
                              getCheckboxAnswers(widget.formFields[3].options,
                                      answers.value[3])
                                  .split(', '), //during seizure symptoms
                              getCheckboxAnswers(widget.formFields[4].options,
                                      answers.value[4])
                                  .split(', '), //post seizure symptoms
                              answers.value[5], //emergency treatment given
                              answers.value[6] //notes

                              ));
                        }
                      },
                      child: Text(
                          AppLocalizations.of(context).translate('Save'),
                          style: MyTextStyle(
                              color: DefaultColors.textColorOnDark))),
                ),
                SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
