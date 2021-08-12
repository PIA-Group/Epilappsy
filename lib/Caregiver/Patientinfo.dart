import 'package:flutter/material.dart';
import 'package:epilappsy/Caregiver/CGHomePage.dart';


//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';


class Patientinfo extends StatefulWidget {
  final Widget child;

  Patientinfo({Key key, this.child}) : super(key: key);

  @override
  _PatientinfoState createState() => _PatientinfoState();
}

class _PatientinfoState extends State<Patientinfo> {
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
                  MaterialPageRoute(builder: (context) => CGHomePage()),
                );
              },
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: Text(AppLocalizations.of(context).translate(
                    'Name')+':'+AppLocalizations.of(context).translate('patient')+'1',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: Text(AppLocalizations.of(context).translate(
                    'age')+' : '+'2',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: Text(AppLocalizations.of(context).translate(
                    'medication')+' : '+AppLocalizations.of(context).translate(
                    'none'),
                    style: new TextStyle(fontSize: 20.0),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: Text(AppLocalizations.of(context).translate(
                    'most common seizure')+' : '+AppLocalizations.of(context).translate('clonic'),
                    style: new TextStyle(fontSize: 20.0),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  width: 300,
                  height: 60,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    onPressed: null,
                    /*() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Patients()),
                                );
                              },*/
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Column(children: [
                      Icon(Icons.location_on_outlined),
                      Text(AppLocalizations.of(context).translate('location')),
                    ]),
                  )),
            ),
          ],
        ));
  }
}