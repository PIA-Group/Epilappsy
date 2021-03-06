import 'package:epilappsy/Pages/RelaxationPage.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/main.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

//for the dictionaries
import '../app_localizations.dart';

class BreathePage extends StatefulWidget {
  double inhale;
  double exhale;
  double hold1;
  double hold2;
  double time;
  String description;
  String breathtype;
  BreathePage(this.inhale, this.hold1, this.exhale, this.hold2, this.time,
      this.description, this.breathtype);

  @override
  _BreathePageState createState() => _BreathePageState();
}

class _BreathePageState extends State<BreathePage>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  AnimationController _breathingController;
  var _breathe = 0.0;
  var _text;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _text = AppLocalizations.of(context).translate('Inhale');

      double totaltime =
          widget.inhale + widget.exhale + widget.hold1 + widget.hold2;

      _breathingController = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.exhale.toInt()), //exhale
        reverseDuration: Duration(seconds: widget.inhale.toInt()), //inhale
        upperBound: 1.0,
        lowerBound: 0.0,
      );
      _breathingController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _breathingController.reverse();
          if (_breathe < (widget.hold2 / totaltime)) {
            _text = AppLocalizations.of(context).translate('Hold');
          } else {
            _text = AppLocalizations.of(context).translate('Exhale');
          }
        } else if (status == AnimationStatus.dismissed) {
          _breathingController.forward();
          if (_breathe > ((totaltime - widget.hold1) / totaltime)) {
            _text = AppLocalizations.of(context).translate('Hold');
          } else {
            _text = AppLocalizations.of(context).translate('Inhale');
          }
        }
      });

      _breathingController.addListener(() {
        setState(() {
          _breathe = _breathingController.value;
        });
      });
      _breathingController.forward();
    });
  }

  var _size = 0.0;

  @override
  Widget build(BuildContext context) {
    //_size = 50.0 + 100.0 * _breathe;
    double totaltime =
        widget.inhale + widget.exhale + widget.hold1 + widget.hold2;
    if (_breathe >= (widget.hold2 / totaltime) &&
        _breathe < ((totaltime - widget.hold1) / totaltime)) {
      _size = 100.0 + 200.0 * _breathe;
    } else if (_breathe > ((totaltime - widget.hold1) / totaltime)) {
      _size = 100.0 + 200.0 * ((totaltime - widget.hold1) / totaltime);
    } else {
      _size = 100.0 + 200.0 * (widget.hold2 / totaltime);
    }
    final size = _size;
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: mycolor,
      appBar: appBarAll(context, null, 'Breath'),
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueGrey[900],
            shape: BoxShape.circle,
          ),
          child: Container(
            height: size,
            width: size,
            child: Container(
                alignment: Alignment.center,
                child: Text(
                  _text,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[800],
                  shape: BoxShape.circle,
                )),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SlideCountdownClock(
              duration: Duration(seconds: widget.time.toInt()),
              shouldShowDays: false,
              slideDirection: SlideDirection.Up,
              separator: ':',
              onDone: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RelaxationPage(
                          widget.inhale,
                          widget.hold1,
                          widget.exhale,
                          widget.hold2,
                          widget.time,
                          widget.description,
                          widget.breathtype),
                    ));
              })
        ],
      ),
    );
  }
}
