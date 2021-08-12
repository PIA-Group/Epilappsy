import 'package:epilappsy/Caregiver/CGHomePage.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkPatient(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(AppLocalizations.of(context).translate('error'.inCaps));
          }
          if (snapshot.data) {
            return HomePage();
          } else {
            return CGHomePage();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}