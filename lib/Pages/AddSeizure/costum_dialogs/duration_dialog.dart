import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/main.dart';

class DurationDialog extends StatefulWidget {
  final ValueNotifier<String> duration;
  final IconData icon;
  final String title;

  DurationDialog({
    Key key,
    this.duration,
    this.icon,
    this.title,
  }) : super(key: key);

  set duration(ValueNotifier<String> duration) {
    duration = duration;
  }

  @override
  _DurationDialogState createState() => _DurationDialogState();
}

class _DurationDialogState extends State<DurationDialog> {
  Function doAfterDone;

  Widget getDurationPicker() {
    setState(() {
      doAfterDone = () {
        Navigator.pop(context);
      };
    });
    return Container(
        height: MediaQuery.of(context).copyWith().size.height / 3,
        child: CupertinoTimerPicker(
            initialTimerDuration: Duration(
                minutes: int.parse(widget.duration.value.split(':')[1]),
                seconds:
                    double.parse(widget.duration.value.split(':')[2]).round()),
            mode: CupertinoTimerPickerMode.ms,
            onTimerDurationChanged: (val) {
              setState(() {
                widget.duration.value = val.toString();
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
            getDurationPicker(),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: doAfterDone,
                child: Text(
                    AppLocalizations.of(context).translate('save').inCaps,
                    style: MyTextStyle()))
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
