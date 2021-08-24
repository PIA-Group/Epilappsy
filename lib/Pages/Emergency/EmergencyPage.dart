import 'package:casia/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:casia/Widgets/appBar.dart';
import 'dart:async';

class EmergencyPage extends StatefulWidget {

  /* final bool flag = true;
  final Stream<int> timerStream;
  final StreamSubscription<int> timerSubscription;
  final String hoursStr = '00';
  final String minutesStr = '00';
  final String secondsStr = '00'; */

  final bool flag;
  final Stream<int> timerStream;
  final StreamSubscription<int> timerSubscription;
  final String hoursStr;
  final String minutesStr;
  final String secondsStr;

  EmergencyPage({Key key, this.flag=true, this.timerStream, this.timerSubscription, this.hoursStr='00', this.minutesStr='00', this.secondsStr='00'}) : super(key: key);

  set flag(bool flag) {
    flag = flag;
  }

  Duration get transitionDuration => Duration(milliseconds: 500);
  bool get opaque => false;  
  bool get barrierDismissible => false;  
  Color get barrierColor => Colors.black.withOpacity(0.8);  
  String get barrierLabel => null;  
  bool get maintainState => true;

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

   @override
  _EmergencyPageState createState() => _EmergencyPageState();
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
