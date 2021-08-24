import 'package:casia/BrainAnswer/form_data.dart';
import 'package:casia/Models/seizure.dart';
import 'package:casia/Pages/AddSeizure/costum_dialogs/checkbox_dialog.dart';
import 'package:casia/Pages/AddSeizure/costum_dialogs/date_dialog.dart';
import 'package:casia/Pages/AddSeizure/costum_dialogs/duration_dialog.dart';
import 'package:casia/Pages/AddSeizure/costum_dialogs/list_tile_dialog.dart';
import 'package:casia/Pages/AddSeizure/questionnaire_tiles.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BAAddSeizurePage extends StatefulWidget {
  final ValueNotifier<String> duration;
  final Seizure seizure;
  final List<FieldData> formFields;
  final String seizureName;

  BAAddSeizurePage({
    this.duration,
    this.seizure,
    this.formFields,
    this.seizureName,
  });

  set duration(ValueNotifier<String> duration) {
    duration = duration;
  }

  @override
  _BAAddSeizurePageState createState() => _BAAddSeizurePageState();
}

class _BAAddSeizurePageState extends State<BAAddSeizurePage> {
  ValueNotifier<List<DateTime>> datePicker;
  ValueNotifier<int> timeOfSeizureIndex;
  Seizure seizure;

  ValueNotifier<List<dynamic>> answers;

  @override
  void initState() {
    super.initState();

    answers = ValueNotifier(List.filled(widget.formFields.length, null));
    _initAnswers();

    datePicker = ValueNotifier(<DateTime>[DateTime.now()]);
    if (widget.duration == null) widget.duration = ValueNotifier('00:00:00.0');
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
      setState(() => answers.value = List.from(answers.value));
    });
  }

  final List<IconTile> timeOfSeizureTiles = [
    IconTile(icon: MdiIcons.alarm, label: 'Ao acordar'),
    IconTile(icon: MdiIcons.weatherSunsetUp, label: 'Manhã'),
    IconTile(icon: MdiIcons.weatherSunsetDown, label: 'Tarde'),
    IconTile(icon: Icons.nights_stay_outlined, label: 'Noite'),
    IconTile(icon: MdiIcons.sleep, label: 'A dormir'),
  ];

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
      appBar: appBarAll(
        context,
        [],
        AppLocalizations.of(context).translate('New Seizure'),
      ),
      body: ListView(children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ListTileDialog(
                          listOfTiles: timeOfSeizureTiles,
                          selectedIndex: timeOfSeizureIndex,
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
                    builder: (BuildContext context, int index, Widget child) {
                      return Text(
                        timeOfSeizureTiles[index].label,
                        //maxLines: 2,
                        style: MyTextStyle(),
                        textAlign: TextAlign.center,
                      );
                    },
                    valueListenable: timeOfSeizureIndex,
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
                    builder: (BuildContext context, List<DateTime> dates,
                        Widget child) {
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
                  widget.duration == null
                      ? Text(
                          "00:00",
                          style: MyTextStyle(),
                          textAlign: TextAlign.center,
                        )
                      : ValueListenableBuilder(
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
            builder: (BuildContext context, List _answers, Widget child) {
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
                //TODO
                Navigator.of(context).pop();
                print(answers.value);
              },
              child: Text(AppLocalizations.of(context).translate('Save'),
                  style: MyTextStyle(color: DefaultColors.textColorOnDark))),
        ),
        SizedBox(height: 20),
      ]),
    );
  }
}
