import 'package:flutter/material.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../app_localizations.dart';

class ConnectedDevicesPage extends StatefulWidget {
  @override
  _ConnectedDevicesPageState createState() => _ConnectedDevicesPageState();
}

class _ConnectedDevicesPageState extends State<ConnectedDevicesPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Health Check'),
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(AppLocalizations.of(context).translate('allow connected device(s)').capitalizeFirstofEach),
                  Switch(
                      activeColor: Colors.teal,
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      })
                ],
              )),
              SizedBox(height: 40),
              FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.teal,
                  onPressed: () {},
                  child:
                      Text(AppLocalizations.of(context).translate('connect'.inCaps), style: TextStyle(color: Colors.white))),
            ],
          ),
        ));
  }
}
