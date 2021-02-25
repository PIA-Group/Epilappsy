import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Caregiver/CGHomePage.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';

class ConnectPatientPage extends StatefulWidget {
  final Widget child;

  ConnectPatientPage({Key key, this.child}) : super(key: key);

  @override
  _ConnectPatientPageState createState() => _ConnectPatientPageState();
}

class _ConnectPatientPageState extends State<ConnectPatientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitleCG(context),
          backgroundColor: Color.fromRGBO(71, 98, 123, 1),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context).translate(
                'The person you will be monitoring will have to scan this code.'),
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CGHomePage()));
                },
                child: QrImage(
                  data: FirebaseAuth.instance.currentUser.uid,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }
}
