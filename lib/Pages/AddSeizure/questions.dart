import 'package:epilappsy/Pages/AddSeizure/costum_dialog.dart';
import 'package:epilappsy/Pages/AddSeizure/questionnaire_tiles.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class QuestionsPage1 extends StatefulWidget {
  @override
  _QuestionsPage1State createState() => _QuestionsPage1State();
}

class _QuestionsPage1State extends State<QuestionsPage1> {
  ValueNotifier<List<DateTime>> datePicker = ValueNotifier([]);
  ValueNotifier<String> duration = ValueNotifier('00:00:00.0');

  @override
  void initState() {
    datePicker.value = <DateTime>[DateTime.now()];
    super.initState();
  }

  final List<QuestionnaireTile> timeOfSeizureTiles = [
    QuestionnaireTile(icon: MdiIcons.alarm, label: 'Upon waking'),
    QuestionnaireTile(icon: MdiIcons.weatherSunsetUp, label: 'Morning'),
    QuestionnaireTile(icon: MdiIcons.weatherSunsetDown, label: 'Afternoon'),
    QuestionnaireTile(icon: Icons.nights_stay_outlined, label: 'Night'),
    QuestionnaireTile(icon: MdiIcons.sleep, label: 'While sleeping'),
  ];

  final ValueNotifier<int> timeOfSeizureIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      SizedBox(
        height: 20,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      listOfTiles: timeOfSeizureTiles,
                      selectedIndex: timeOfSeizureIndex,
                      icon: Icons.access_time_rounded,
                      title: 'Time of seizure',
                      type: 'listTile',
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
                    return CustomDialogBox(
                      datePicker: datePicker,
                      icon: Icons.calendar_today_outlined,
                      title: 'Date(s) of seizure(s)',
                      type: 'date',
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
                    return CustomDialogBox(
                      duration: duration,
                      icon: Icons.timer_rounded,
                      title: 'Duration of seizure',
                      type: 'duration',
                    );
                  });
            },
            child: Column(children: [
              Icon(Icons.timer_rounded,
                  size: 30, color: DefaultColors.mainColor),
              ValueListenableBuilder(
                builder: (BuildContext context, String time, Widget child) {
                  return Text(
                    "${time.split(':')[1]}:${time.split(':')[2].substring(0, time.split(':')[2].indexOf('.'))}",
                    style: MyTextStyle(),
                    textAlign: TextAlign.center,
                  );
                },
                valueListenable: duration,
              ),
            ]),
          ),
        ),
      ]),
      SizedBox(
        height: 20,
      ),
    ]);
  }
}

class QuestionsPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}

class QuestionsPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}
