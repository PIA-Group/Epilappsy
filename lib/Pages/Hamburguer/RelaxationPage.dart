import 'package:casia/Pages/Hamburguer/TOBPage.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';
import 'package:casia/Pages/BreathPage.dart';
import 'package:casia/main.dart';

class RelaxationPage extends StatefulWidget {
  final double _inhale;
  final double _exhale;
  final double _hold1;
  final double _hold2;
  final double _time;
  final String _description;
  final String _breathtype;
  final Color _color;

  RelaxationPage(this._inhale, this._hold1, this._exhale, this._hold2,
      this._time, this._description, this._breathtype, this._color);

  set _time(double _time) {
    _time = _time;
  }

  @override
  _RelaxationPageState createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage> {
  //int _selectedIndex = -1;
  //var _color = Colors.black;

  @override
  Widget build(BuildContext context) {
    print('duration ${widget._time}');
    return Scaffold(
      backgroundColor: mycolor,
      body: Stack(children: [
        AppBarAll(
          context: context,
          titleH: widget._breathtype,
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
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 600,
                width: 300,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child:
                        /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Switch(
                    value: state,
                    onChanged: (bool s){
                      setState(() {
                        state=s;
                      print(state);
                      })
                    },
                  ),
                  Text('Guided with voice assistant')
                ]),*/
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Text(
                            widget._description,
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.justify,
                            maxLines: 6,
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          alignment: Alignment.center,
                        )
                      ],
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('duration')
                                .inCaps,
                            style: new TextStyle(fontSize: 18.0),
                          ),
                          height: 60,
                          width: 300,
                          alignment: Alignment.bottomCenter,
                        )
                      ]),
                  //TODO: maybe change to another type of button so the one that is selected has a different color
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonBar(
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: DefaultColors.mainColor),
                              onPressed: () {
                                widget._time = 60.0;
                              },
                              child: Text('1min', style: MyTextStyle()),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: DefaultColors.mainColor),
                              onPressed: () {
                                widget._time = 120.0;
                              },
                              child: Text('2min', style: MyTextStyle()),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: DefaultColors.mainColor),
                              onPressed: () {
                                widget._time = 300.0;
                              },
                              child: Text('5min', style: MyTextStyle()),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: DefaultColors.mainColor),
                              onPressed: () {
                                widget._time = 600.0;
                              },
                              child: Text('10min', style: MyTextStyle()),
                            ),
                          ],
                        )
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 200.0,
                          width: 100.0,
                          child: FittedBox(
                            child: FloatingActionButton(
                              backgroundColor: Colors.blueGrey[800],
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BreathePage(
                                            widget._inhale,
                                            widget._hold1,
                                            widget._exhale,
                                            widget._hold2,
                                            widget._time,
                                            widget._description,
                                            widget._breathtype,
                                            widget._color)));
                              },
                              child: new Icon(Icons.play_arrow,
                                  size: 40, color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
