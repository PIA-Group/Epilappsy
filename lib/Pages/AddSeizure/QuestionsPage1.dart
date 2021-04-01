import 'package:epilappsy/Pages/AddSeizure/costum_dialog.dart';
import 'package:epilappsy/Pages/AddSeizure/questionnaire_tiles.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:chips_choice/chips_choice.dart';

class QuestionsPage1 extends StatefulWidget {
  final ValueNotifier<List<DateTime>> datePicker;
  final ValueNotifier<String> duration;
  final ValueNotifier<String> seizureType;
  final ValueNotifier<String> seizureItem;
  final ValueNotifier<int> timeOfSeizureIndex;
  List<String> seizureTypes;
  List<String> seizureTypesItems;

  QuestionsPage1(
      {this.datePicker,
      this.duration,
      this.seizureType,
      this.seizureItem,
      this.timeOfSeizureIndex,
      this.seizureTypes,
      this.seizureTypesItems});

  @override
  _QuestionsPage1State createState() => _QuestionsPage1State();
}

class _QuestionsPage1State extends State<QuestionsPage1> {
  @override
  void initState() {
    widget.seizureType.addListener(() {
      if (widget.seizureType.value == 'Other')
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                textNotifier: widget.seizureType,
                icon: Icons.bolt,
                title: 'Add New Seizure Type',
                type: 'textfield',
              );
            });
      else if (!widget.seizureTypesItems.contains(widget.seizureType.value)) {
        String aux = widget.seizureType.value.trim();
        aux = '${aux[0].toUpperCase()}${aux.substring(1).toLowerCase()}';
        widget.seizureTypesItems = List.from(widget.seizureTypesItems)
          ..add(aux);
        setState(() => widget.seizureItem.value = aux);
        //TODO: function to add new seizure type to firestore
      }
    });
    super.initState();
  }

  final List<QuestionnaireTile> timeOfSeizureTiles = [
    QuestionnaireTile(icon: MdiIcons.alarm, label: 'Upon waking'),
    QuestionnaireTile(icon: MdiIcons.weatherSunsetUp, label: 'Morning'),
    QuestionnaireTile(icon: MdiIcons.weatherSunsetDown, label: 'Afternoon'),
    QuestionnaireTile(icon: Icons.nights_stay_outlined, label: 'Night'),
    QuestionnaireTile(icon: MdiIcons.sleep, label: 'While sleeping'),
  ];

  List<String> tags = [];

  // list of string options
  List<String> options = [
    'News', 'Entertainment', 'Politics',
    'Automotive', 'Sports', 'Education',
    'Fashion', 'Travel', 'Food', 'Tech',
    'Science',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: [
      SizedBox(height: 20),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialogBox(
                        listOfTiles: timeOfSeizureTiles,
                        selectedIndex: widget.timeOfSeizureIndex,
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
                  valueListenable: widget.timeOfSeizureIndex,
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
                        datePicker: widget.datePicker,
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
                  valueListenable: widget.datePicker,
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
                        duration: widget.duration,
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
                  valueListenable: widget.duration,
                ),
              ]),
            ),
          ),
        ]),
      ),
      SizedBox(height: 20),
      Divider(
          //color: Colors.white,
          height: 0,
          thickness: 2,
          indent: 15,
          endIndent: 15),
      SizedBox(height: 20),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Text('Seizure Type',
            style: MyTextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15),
        child: Container(
          //height: 35,
          padding: EdgeInsets.all(5),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.5,
                  style: BorderStyle.solid,
                  color: DefaultColors.accentColor),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              isDense: true,
              isExpanded: true,
              value: widget.seizureItem.value,
              iconSize: 24,
              elevation: 16,
              style: MyTextStyle(),
              onChanged: (String newValue) {
                setState(() {
                  widget.seizureItem.value = newValue;
                  widget.seizureType.value = newValue;
                });
              },
              items: widget.seizureTypesItems
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      SizedBox(height: 20),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Text('Potential Triggers',
            style: MyTextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15),
        child: ChipsChoice<String>.multiple(
          value: tags,
          onChanged: (val) => setState(() => tags = val),
          choiceItems: C2Choice.listFrom<String, String>(
            source: options,
            value: (i, v) => v,
            label: (i, v) => v,
            tooltip: (i, v) => v,
          ),
          wrapped: true,
          textDirection: TextDirection.rtl,
        ),
      ),
    ]);
  }
}
