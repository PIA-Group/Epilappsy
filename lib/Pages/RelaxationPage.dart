import 'package:casia/Pages/TOBPage.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';
import 'package:casia/Pages/BreathPage.dart';
import 'package:casia/main.dart';

class RelaxationPage extends StatefulWidget {
  double _inhale;
  double _exhale;
  double _hold1;
  double _hold2;
  double _time;
  String _description;
  String _breathtype;
  RelaxationPage(this._inhale, this._hold1, this._exhale, this._hold2,
      this._time, this._description, this._breathtype);
  @override
  _RelaxationPageState createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage> {
  //int _selectedIndex = -1;
  //var _color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mycolor,
      appBar: appBarAll(
        context,
        null,
        widget._breathtype
        //'Relaxing exercises',
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          height: 600,
          width: 300,
          child: Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TOBPage()),
                      );
                    },
                    icon: Icon(
                      Icons.local_florist_outlined,
                      size: 30.0,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate('Types of exercises'),
                    style: new TextStyle(fontSize: 18.0),
                  )
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text(
                    widget._breathtype,
                    style: new TextStyle(fontSize: 14.0),
                    textAlign: TextAlign.left,
                  ),
                  width: 300,
                  height: 50,
                  alignment: Alignment.center,
                )
              ],
            ),
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
                    style: new TextStyle(fontSize: 14.0),
                    textAlign: TextAlign.justify,
                  ),
                  width: 300,
                  height: 60,
                  alignment: Alignment.topCenter,
                )
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                child: Text(
                  AppLocalizations.of(context).translate('Time duration'),
                  style: new TextStyle(fontSize: 18.0),
                ),
                height: 60,
                width: 300,
                alignment: Alignment.bottomCenter,
              )
            ]),
            //TODO: maybe change to another type of button so the one that is selected has a different color
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ButtonBar(
                children: <Widget>[
                  TextButton(
                    style:
                        TextButton.styleFrom(primary: DefaultColors.mainColor),
                    onPressed: () {
                      widget._time = 60.0;
                    },
                    child: Text('1min', style: MyTextStyle()),
                  ),
                  TextButton(
                    style:
                        TextButton.styleFrom(primary: DefaultColors.mainColor),
                    onPressed: () {
                      widget._time = 120.0;
                    },
                    child: Text('2min', style: MyTextStyle()),
                  ),
                  TextButton(
                    style:
                        TextButton.styleFrom(primary: DefaultColors.mainColor),
                    onPressed: () {
                      widget._time = 300.0;
                    },
                    child: Text('5min', style: MyTextStyle()),
                  ),
                  TextButton(
                    style:
                        TextButton.styleFrom(primary: DefaultColors.mainColor),
                    onPressed: () {
                      widget._time = 600.0;
                    },
                    child: Text('10min', style: MyTextStyle()),
                  ),
                ],
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                                  widget._breathtype)));
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
      /*floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Container(
        height: 100.0,
        width: 100.0,
        child: Container(
          height: 200.0,
        width: 100.0,
          child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.green[500],
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
                          widget._breathtype)));
            },
            child: new Icon(Icons.play_arrow, size: 40),
          ),
        ),
      ),)*/
      /*bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        //onTap: _onItemTapped,
        backgroundColor: Colors.teal,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _selectedIndex == 1 ? Colors.grey : Colors.black),
              label: 'Home'),
          /*BottomNavigationBarItem(
              icon: Icon(Icons.content_paste,
                  color: _selectedIndex == 1 ? Colors.grey : Colors.black),
              label: 'Diary'),
          BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement,
                  color: _selectedIndex == -1 ? Colors.grey : Colors.black),
              label: 'Relax'),*/
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box,
                  color: _selectedIndex == 1 ? Colors.grey : Colors.black),
              label: 'Profile'),
        ],
      ),*/
    );
  }
}
