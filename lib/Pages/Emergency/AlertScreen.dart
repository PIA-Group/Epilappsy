import 'dart:async';
import 'package:casia/Pages/AddSeizure/NewSeizureTransitionPage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/main.dart';

//for the dictionaries
import '../../app_localizations.dart';

class AlertScreen extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.white;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

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

  
  Widget emergencyButton(BuildContext context, String hour, String min,
      String secs, double sizeEm, IconData iconC, Color colorC, String textEm) {
    return Column(children: [
      Container(
          height: sizeEm + 15,
          width: sizeEm + 15,
          decoration: BoxDecoration(color: colorC, shape: BoxShape.circle),
          child: GestureDetector(
              //padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              onTap: () {
                if (textEm == 'dismiss') {
                  Navigator.pop(context);
                } else if (textEm == "I'm ok now") {
                  timerSubscription.cancel();
                  Navigator.of(context).pop();
                  pushDynamicScreen(
                    context,
                    screen: NewSeizureTransitionPage(
                        duration: ValueNotifier('$hour:$min:$secs.0')),
                    withNavBar: false,
                  );
                } else if (textEm == 'emergency') {
                  //TODO
                  Navigator.pop(context);
                }
                
              },
              child: Icon(
                iconC,
                size: sizeEm,
                color: DefaultColors.backgroundColor,
              ))),
      Text(
        AppLocalizations.of(context).translate(textEm).inCaps,
        style: TextStyle(
          color: colorC,
          fontSize: 20.0,
        ),
      )
    ]);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    if (_i == 0) {
      timerStream = stopWatchStream();
      timerSubscription = timerStream.listen((int newTick) {
        setState(() {
          _i = 1;
          hoursStr =
              ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
          minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
          secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
        });
        changedExternalState();
      });
    }
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 0),
          child: Image.asset('assets/images/barra.png')),
      Container(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.height * 0.35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: DefaultColors.alarmColor, shape: BoxShape.circle),
        child: Text(
          "$hoursStr:$minutesStr:$secondsStr",
          style: TextStyle(
            color: Colors.white,
            fontSize: 50.0,
          ),
        ),
      ),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              emergencyButton(context, hoursStr, minutesStr, secondsStr, 30.0,
                  Icons.check, DefaultColors.purpleLogo, "I'm ok now"),
              emergencyButton(context, hoursStr, minutesStr, secondsStr, 70,
                  Icons.alarm, DefaultColors.alarmColor, "Emergency"),
              emergencyButton(context, hoursStr, minutesStr, secondsStr, 30,
                  Icons.alarm_off, DefaultColors.purpleLogo, "Dismiss")
            ],
          )),
    ]));
  }
}
