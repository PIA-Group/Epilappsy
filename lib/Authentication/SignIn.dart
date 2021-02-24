import 'package:epilappsy/Authentication/SignUp.dart';
import 'package:epilappsy/Authentication/authenthicate.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(71, 98, 123, 1),
        body: Form(
          key: _formKey,
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    child: RichText(
                      text: TextSpan(style: TextStyle(fontSize: 40), children: [
                        TextSpan(
                            text: 'Health',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        TextSpan(
                            text: 'Check',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(219, 213, 110, 1))),
                      ]),
                    ),
                  ),
                  Container(
                    height: 20,
                    child: Text(error,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
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
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      validator: (String val) {
                        return val.contains('@')
                            ? AppLocalizations.of(context).translate('Has to be a valid Email.')
                            : null;
                      },
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: 'Email'),
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
                        textAlign: TextAlign.center,
                        validator: (String val) {
                          return val.isEmpty ? AppLocalizations.of(context).translate('You need a password.') : null;
                        },
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: AppLocalizations.of(context).translate('Password')),
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
                          .signIn(
                            email: email,
                            password: password,
                            thiscontext: context,
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
                        child: Text(AppLocalizations.of(context).translate('Sign in'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context).translate("Don't have an account? "),
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Text(AppLocalizations.of(context).translate("Sign up"),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                ],
              )),
        ));
  }
}
