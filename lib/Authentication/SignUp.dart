import 'package:epilappsy/Authentication/SignIn.dart';
import 'package:epilappsy/Authentication/WelcomePage.dart';
import 'package:epilappsy/Authentication/authenthicate.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Models/patient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String email, password, name;
  bool _isPatient = true;
  String error = '';

  void _handleRadioValueChange(bool val) {
    setState(() {
      _isPatient = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Health Check'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              height: 20,
              child: Text(error,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  )),
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Radio(
                value: true,
                groupValue: _isPatient,
                onChanged: _handleRadioValueChange,
              ),
              Text(
                AppLocalizations.of(context).translate('Patient'),
                style: new TextStyle(fontSize: 16.0),
              ),
              Radio(
                value: false,
                groupValue: _isPatient,
                onChanged: _handleRadioValueChange,
              ),
              Text(
                AppLocalizations.of(context).translate('Caregiver'),
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              )
            ]),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              height: 50,
              width: MediaQuery.of(context).size.width - 48,
              alignment: Alignment.center,
              child: TextFormField(
                validator: (String val) {
                  return val.isEmpty ? AppLocalizations.of(context).translate('You need an email.') : null;
                },
                decoration: new InputDecoration(hintText: 'Email'),
                onChanged: (val) {
                  email = val;
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              height: 50,
              width: MediaQuery.of(context).size.width - 48,
              alignment: Alignment.center,
              child: Center(
                child: TextFormField(
                  obscureText: true,
                  validator: (String val) {
                    return val.isEmpty ? AppLocalizations.of(context).translate('You need a password.') : null;
                  },
                  decoration: new InputDecoration(hintText: 'Password'),
                  onChanged: (val) {
                    password = val;
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                context
                    .read<AuthenticationService>()
                    .signUp(
                      email: email,
                      password: password,
                      thiscontext: context,
                      isPatient: _isPatient,
                    )
                    .then((value) {
                  error = value;
                  setState(() {});
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 50,
                  width: MediaQuery.of(context).size.width - 48,
                  alignment: Alignment.center,
                  child: Text('Sign up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))),
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).translate("Already have an account? "),
                    style: TextStyle(color: Colors.black, fontSize: 15)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: Text(AppLocalizations.of(context).translate("Sign in"),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
