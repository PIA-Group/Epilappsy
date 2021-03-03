import 'package:epilappsy/Authentication/authenthicate.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//for the dictionaries
import '../app_localizations.dart';

class SettingsPage extends StatefulWidget {
  final Widget child;

  SettingsPage({Key key, this.child}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitle(context),
          backgroundColor: Color.fromRGBO(71, 123, 117, 1),
        ),
        body: Center(
          child: RaisedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('Sign Out')),
          ),
        ));
  }
}
