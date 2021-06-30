import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Pages/Medication/medication_answers.dart';
import 'package:epilappsy/app_localizations.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../questionnaire_tiles.dart';
import 'list_tile_dialog.dart';


class TimeDialog extends StatefulWidget {
  final ValueNotifier<String> time;
  final ValueNotifier<IconData> periodOfDay;
  final IconData icon;
  final String title;

  const TimeDialog({
     Key key,
    this.time,
    this.periodOfDay,
    this.icon,
    this.title,
  }) : super(key: key);

  @override
  _TimeDialogState createState() => _TimeDialogState();
}

class _TimeDialogState extends State<TimeDialog> {
  Function doAfterDone;
  Answers _answers;

  
  int _selected = null;
  

  Widget getTimePicker() {
    setState(() {
      doAfterDone = () {
        //save all the things into _answers
        Navigator.pop(context);
      };
    });
    return Container(
        height: MediaQuery.of(context).copyWith().size.height / 3,
        child: CupertinoTimerPicker(
            initialTimerDuration: Duration(
                hours: DateTime.now().hour,
                minutes:DateTime.now().minute),
                mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: (value) {
              setState(() {
                print(widget.time.value.toString());
                widget.time.value = value.toString();
                
              });
            }));
  }

  Widget _item(int index, {String label, IconData icon}) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: _selected == index ? DefaultColors.mainColor : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
              Icon(
                icon,
                color: _selected == index ? DefaultColors.textColorOnDark : null,
              ),
              Text(AppLocalizations.of(context).translate(label), 
              style: TextStyle(
                fontSize: 15,
                color: _selected == index ? DefaultColors.textColorOnDark : null)),
            ]),
        onPressed: () => setState(
          () {
            _selected = index;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 60, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: ListView(shrinkWrap: true, children: <Widget>[
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: MyTextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            SizedBox(height: 20),

            Column(
              children: [
                _item(0, label: 'Upon awakening', 
                      icon: MdiIcons.alarm),
                _item(1, label: 'While sleeping', 
                      icon: MdiIcons.sleep),
                _item(2, label: 'During the day', 
                      icon: MdiIcons.accountTie),
              ],
            ),
            
            getTimePicker(),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: doAfterDone,
                child: Text(AppLocalizations.of(context)
                                      .translate('Done'), style: MyTextStyle()))
          ])),
          Positioned(
            left: 20,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(60)),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(widget.icon,
                      size: 30, color: DefaultColors.accentColor),
              ),
            ),
          ),
        ),
      ]
    );
  }
}

