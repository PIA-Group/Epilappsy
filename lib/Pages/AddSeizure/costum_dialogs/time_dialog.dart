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
  final IconData icon;
  final String title;

  const TimeDialog({
     Key key,
    this.time,
    this.icon,
    this.title,
  }) : super(key: key);

  @override
  _TimeDialogState createState() => _TimeDialogState();
}

class _TimeDialogState extends State<TimeDialog> {
  Function doAfterDone;

  
  final List<IconTile> timeOfSeizureTiles = [
      IconTile(icon: MdiIcons.alarm, label: "Ao acordar"),
      IconTile(icon: MdiIcons.sleep, label: 'A dormir'),
    ];

  Widget geTimePicker() {
    setState(() {
      doAfterDone = () {
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
                widget.time.value = value.toString();
                print(widget.time.value);
              });
            }));
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
              style: MyTextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Center(child: Row (children: [ 
              RaisedButton(
              onPressed: () {},
              elevation: 5,
              color: DefaultColors.backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      MdiIcons.alarm,
                      color: DefaultColors.textColorOnLight,
                    ),
                    Text(
                      'Ao acordar',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: DefaultColors.textColorOnLight,
                      ),
                    ),
                    
                  ],
                ),
              ),
              RaisedButton(
              onPressed: () {},
              elevation: 5,
              color: DefaultColors.backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      MdiIcons.sleep,
                      color: DefaultColors.textColorOnLight,
                    ),
                    Text(
                      'A dormir',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: DefaultColors.textColorOnLight,
                      ),
                    ),
                    
                  ],
                ),
              ),],)
              ),
           

            geTimePicker(),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: doAfterDone,
                child: Text(AppLocalizations.of(context)
                                      .translate('Done'), style: MyTextStyle()))
          ]),
        ),
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
      ],
    );
  }
}
