import 'package:epilappsy/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'dart:async';
import 'package:epilappsy/Pages/AddSeizure/AddSeizurePage.dart';
import 'package:epilappsy/Pages/AddSeizure/NewSeizureTransitionPage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class EmergencyPage extends StatefulWidget {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;
  EmergencyPage({Key key}) : super(key: key);

  @override
  _EmergencyPageState createState() => _EmergencyPageState();

  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  int _i = 0;

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }
}

class _EmergencyPageState extends State<EmergencyPage> {
  Widget circularCounter(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.40,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: DefaultColors.backgroundColor),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.30,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: DefaultColors.alarmColor),
          child: Text(
            "00",
            style: TextStyle(
              color: Colors.white,
              fontSize: 90.0,
            ),
          ),
        ));
  }

  Widget rowResponse() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                    color: DefaultColors.purpleLogo, shape: BoxShape.circle),
                child: Icon(
                  Icons.check,
                  size: 40,
                  color: DefaultColors.textColorOnDark,
                )),
            Text(
              "I'am OK",
              style: TextStyle(fontSize: 18.0, color: DefaultColors.purpleLogo),
            )
          ],
        ),
        Column(children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                  color: DefaultColors.alarmColor, shape: BoxShape.circle),
              child: Icon(
                Icons.add_call,
                size: 40,
                color: DefaultColors.textColorOnDark,
              )),
          Text(
            'Emergency',
            style: TextStyle(fontSize: 18.0, color: DefaultColors.alarmColor),
          )
        ]),
        Column(children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                  color: DefaultColors.purpleLogo, shape: BoxShape.circle),
              child: Icon(
                Icons.alarm_off,
                size: 40,
                color: DefaultColors.textColorOnDark,
              )),
          Text(
            'Dismiss',
            style: TextStyle(fontSize: 18.0, color: DefaultColors.purpleLogo),
          )
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.green[100],
        appBar: appBarEmergency(context, [], 'Emergency' + '\n'),
        body: Column(
          children: [
            circularCounter(context),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            rowResponse()
          ],
        ));
  }
}
