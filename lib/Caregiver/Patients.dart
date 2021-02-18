import 'package:flutter/material.dart';
import 'package:epilappsy/Caregiver/CGHomePage.dart';
import 'package:epilappsy/Caregiver/Patientinfo.dart';


class Patients extends StatefulWidget {
  final Widget child;

  Patients({Key key, this.child}) : super(key: key);

  @override
  _PatientsState createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.home_filled,
                  size: 24.0,
                  color: Colors.white,
                ),
                onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CGHomePage()),
                                );
                              },)
          ],
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text('Health'),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                child: Icon(Icons.check_box_outlined, size: 24.0),
              )
            ],
          ),
          backgroundColor: Colors.teal,
        ),
        body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text('Patient1',
                              style: new TextStyle(fontSize: 15.0))),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20.0,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Patientinfo()),
                                );
                              })),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'Patient2',
                            style: new TextStyle(fontSize: 15.0),
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'Patient3',
                            style: new TextStyle(fontSize: 15.0),
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'Patient4',
                            style: new TextStyle(fontSize: 15.0),
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'Patient5',
                            style: new TextStyle(fontSize: 15.0),
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: new FittedBox(
              child: Material(
                  color: Colors.green[100],
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(24.0),
                  shadowColor: Color(0x802196F3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'Patient6',
                            style: new TextStyle(fontSize: 15.0),
                          )),
                      //),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.centerRight,
                          //child: ClipRRect(
                          //borderRadius: new BorderRadius.circular(24.0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.0),
                              onPressed: null)),
                      //),
                    ],
                  )),
            )),
          ),
        ]));
  }
}
