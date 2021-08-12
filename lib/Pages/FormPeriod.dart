import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/main.dart';
//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';

class FormPeriod extends StatefulWidget {
  FormPeriod({Key key}) : super(key: key);

  @override
  _FormPeriodState createState() => _FormPeriodState();
}

class _FormPeriodState extends State<FormPeriod> {
  String _data;
  String _symptoms;
  String _moods;
  String _birthcontrolpills;

  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

  Widget _builddata() {
    return TextFormField(
      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('data'.inCaps)),
      maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return AppLocalizations.of(context).translate('name is required'.inCaps);
        }

        return null;
      },
      onSaved: (String value) {
        _data = value;
      },
    );
  }

  Widget _buildsymptoms() {
    return TextFormField(
      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('symptoms'.inCaps)),
      validator: (String value) {
        if (value.isEmpty) {
          return AppLocalizations.of(context).translate('email is required'.inCaps);
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return AppLocalizations.of(context).translate('please enter a valid email address'.inCaps);
        }

        return null;
      },
      onSaved: (String value) {
        _symptoms = value;
      },
    );
  }

  Widget _buildmoods() {
    return TextFormField(
      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('moods'.inCaps)),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return AppLocalizations.of(context).translate('password is required'.inCaps);
        }

        return null;
      },
      onSaved: (String value) {
        _moods = value;
      },
    );
  }

  Widget _builbcp() {
    return TextFormField(
      decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('birth control pills'.capitalizeFirstofEach)),
      keyboardType: TextInputType.url,
      validator: (String value) {
        if (value.isEmpty) {
          return AppLocalizations.of(context).translate('URL is required');
        }

        return null;
      },
      onSaved: (String value) {
        _birthcontrolpills = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green[100],
      appBar: AppBar(
        elevation: 0.0,
        title: appBarTitle(context),
        backgroundColor: Color.fromRGBO(71, 123, 117, 1),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _scaffoldkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _builddata(),
              _buildsymptoms(),
              _buildmoods(),
              _builbcp(),
              SizedBox(height: 100),
              RaisedButton(
                child: Text(AppLocalizations.of(context).translate(
                  'submit'.inCaps),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: null, //() {
                /*if (!_scaffoldkey.currentState.validate()) {
                    return;
                  }

                  _scaffoldkey.currentState.save();

                  print(_name);
                  print(_email);
                  print(_phoneNumber);
                  print(_url);
                  print(_password);
                  print(_calories);

                  //Send to API
                },*/
              )
            ],
          ),
        ),
      ),
    );
  }
}
