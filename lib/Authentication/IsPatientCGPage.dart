import 'package:epilappsy/Caregiver/CGHomePage.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Pages/NavigationPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//for the dictionaries
import '../app_localizations.dart';

class IsPatientCGPage extends StatefulWidget {
  IsPatientCGPage(this.loginToken);
  final String loginToken;
  
  @override
  _IsPatientCGPageState createState() => _IsPatientCGPageState();
}

class _IsPatientCGPageState extends State<IsPatientCGPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkIfPatient(), //TODO: verify if this makes sense with BA API
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(AppLocalizations.of(context).translate('Error'));
          }
          if (snapshot.data) {
            return NavigationPage(widget.loginToken);
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
