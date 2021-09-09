import 'dart:async';

import 'package:casia/Utils/appBar.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/main.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

//for the dictionaries
import '../../Utils/app_localizations.dart';

class BreathePage extends StatefulWidget {
  final double inhale;
  final double exhale;
  final double hold1;
  final double hold2;
  final double time;
  final String description;
  final String breathtype;
  final Color _color;
  BreathePage(this.inhale, this.hold1, this.exhale, this.hold2, this.time,
      this.description, this.breathtype, this._color);

  @override
  _BreathePageState createState() => _BreathePageState();
}

class _BreathePageState extends State<BreathePage>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  AnimationController _breathingController;
  double totaltime;
  ValueNotifier<String> _text = ValueNotifier('');
  var _breathe = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _text.value = AppLocalizations.of(context).translate('inhale').inCaps;

      totaltime = widget.inhale + widget.exhale + widget.hold1 + widget.hold2;

      _breathingController = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.inhale.toInt()), // inhale
        reverseDuration: Duration(seconds: widget.exhale.toInt()), // exhale
        upperBound: 1.0,
        lowerBound: 0.0,
      );

      _breathingController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _text.value = AppLocalizations.of(context).translate('hold').inCaps;
          Future.delayed(Duration(seconds: widget.hold1.floor())).then((value) {
            _breathingController.reverse();
            _text.value =
                AppLocalizations.of(context).translate('exhale').inCaps;
          });
        } else if (status == AnimationStatus.dismissed) {
          _text.value = AppLocalizations.of(context).translate('hold').inCaps;
          Future.delayed(Duration(seconds: widget.hold2.floor())).then((value) {
            _breathingController.forward();
            _text.value =
                AppLocalizations.of(context).translate('inhale').inCaps;
          });
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

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
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
      body: Stack(children: [
        AppBarAll(
          context: context,
          titleH: widget.breathtype,
        ),
        Positioned(
          top: AppBarAll.appBarHeight,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                color: DefaultColors.backgroundColor,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SlideCountdownClock(
                    textStyle: Theme.of(context).textTheme.headline3,
                    duration: Duration(seconds: widget.time.toInt()),
                    shouldShowDays: false,
                    slideDirection: SlideDirection.Up,
                    separator: ':',
                    onDone: () {
                      //_breathingController.dispose();
                      Navigator.pop(context);
                    }),
                ValueListenableBuilder(
                    valueListenable: _text,
                    builder: (BuildContext context, String value, _) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Container(
                          height: size,
                          width: size,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(_text.value,
                                style: Theme.of(context).textTheme.headline1),
                            decoration: BoxDecoration(
                              color: widget._color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
