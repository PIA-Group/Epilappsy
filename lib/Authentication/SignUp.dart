import 'package:epilappsy/Authentication/SignInBA.dart';
import 'package:epilappsy/Authentication/authenthicate.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//for the dictionaries
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
        backgroundColor: Color.fromRGBO(71, 98, 123, 1),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: 150,
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
                ),
                Theme(
                  data: ThemeData(
                    //here change to your color
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          activeColor: Colors.white,
                          value: true,
                          groupValue: _isPatient,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('Patient'),
                          style: new TextStyle(
                              color: Colors.white, fontSize: 16.0),
                        ),
                        Radio(
                          activeColor: Colors.white,
                          value: false,
                          groupValue: _isPatient,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('Caregiver'),
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        )
                      ]),
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
                          ? AppLocalizations.of(context)
                              .translate('Has to be a valid Email.')
                          : null;
                    },
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 10, right: 15),
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
                        return val.isEmpty
                            ? AppLocalizations.of(context)
                                .translate('You need a password.')
                            : null;
                      },
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 10, right: 15),
                          hintText: 'Password'),
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
                    Text(
                        AppLocalizations.of(context)
                            .translate("Already have an account?"),
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text(
                          AppLocalizations.of(context).translate("Sign in"),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ));
  }
}
