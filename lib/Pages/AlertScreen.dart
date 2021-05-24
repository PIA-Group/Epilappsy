import 'dart:async';
import 'package:epilappsy/Pages/AddSeizure/AddSeizurePage.dart';
import 'package:epilappsy/Pages/AddSeizure/NewSeizureTransitionPage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

//for the dictionaries
import '../app_localizations.dart';

class AlertScreen extends ModalRoute<void> {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "$hoursStr:$minutesStr:$secondsStr",
            style: TextStyle(
              color: Colors.white,
              fontSize: 90.0,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            //padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            onPressed: () {
              timerSubscription.cancel();
              pushDynamicScreen(
                context,
                screen: NewSeizureTransitionPage(
                    duration:
                        ValueNotifier('$hoursStr:$minutesStr:$secondsStr.0')),
                withNavBar: false,
              );
              /* Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BAAddSeizurePage(
                        duration: ValueNotifier(
                            '$hoursStr:$minutesStr:$secondsStr.0')),
                    /* SurveyPage(
                          duration: "$hoursStr:$minutesStr:$secondsStr") */
                  )); */
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(149, 214, 56, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60)),
            ),
            //color: Color.fromRGBO(149, 214, 56, 1),
            child: Text(
              AppLocalizations.of(context).translate('I am ok now'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {}, //TODO
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60)),
            ),
            child: Text(
              AppLocalizations.of(context).translate('Emergency'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60)),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context).translate('Dismiss'),
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
