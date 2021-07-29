import 'package:epilappsy/Pages/TOBPage.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/Pages/BreathPage.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';

class RelaxationPage extends StatefulWidget {
  double _inhale;
  double _exhale;
  double _hold1;
  double _hold2;
  double _time;
  RelaxationPage(
      this._inhale, this._hold1, this._exhale, this._hold2, this._time);
  @override
  _RelaxationPageState createState() => _RelaxationPageState();
}

class _RelaxationPageState extends State<RelaxationPage> {
  int _selectedIndex = -1;
  var _color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(71, 123, 117, 1),
        title: appBarTitle(context),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          height: 300,
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
                    icon: Icon(Icons.local_florist_outlined),
                  ),
                  Text(AppLocalizations.of(context).translate('types of exercises').inCaps)
                ]),
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
                children: [Text(AppLocalizations.of(context).translate('time duration'.inCaps))]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        widget._time = 60.0;
                      },
                      child: Text(AppLocalizations.of(context).translate('1min')),
                      highlightColor: Colors.grey[500]),
                  FlatButton(
                      onPressed: () {
                        widget._time = 120.0;
                      },
                      child: Text(AppLocalizations.of(context).translate('2min')),
                      highlightColor: Colors.grey[500]),
                  FlatButton(
                      onPressed: () {
                        widget._time = 300.0;
                      },
                      child: Text(AppLocalizations.of(context).translate('5min')),
                      highlightColor: Colors.grey[500]),
                  FlatButton(
                      onPressed: () {
                        widget._time = 600.0;
                      },
                      child: Text(AppLocalizations.of(context).translate('10min')),
                      highlightColor: Colors.grey[500]),
                ],
              )
            ]),
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 100.0,
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
                          widget._time)));
            },
            child: new Icon(Icons.play_arrow, size: 40),
          ),
        ),
      ),
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
