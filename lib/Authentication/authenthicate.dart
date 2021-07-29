import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Authentication/RegisteringPage.dart';
import 'package:epilappsy/Caregiver/ConnectPatient.dart';
import 'package:flutter/material.dart';

import '../main.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String> signIn(
      {String email, String password, BuildContext thiscontext}) async {
    String errorMessage;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print(error.code);
      switch (error.code) {
        case "invalid-email":
          errorMessage = Text(AppLocalizations.of(thiscontext)
                  .translate('your email address appears to be invalid'.inCaps)+".")
              as String;
          break;
        case "wrong-password":
          errorMessage = Text(AppLocalizations.of(thiscontext)
              .translate('your password is invalid'.inCaps)+".") as String;
          break;
        case "user-not-found":
          errorMessage = Text(AppLocalizations.of(thiscontext)
              .translate("user with this email doesn't exist".inCaps)+".") as String;
          break;
        case "user-disabled":
          errorMessage = Text(AppLocalizations.of(thiscontext)
              .translate("user with this email has been disabled".inCaps)+".") as String;
          break;
        case "too-many-requests":
          errorMessage = Text(AppLocalizations.of(thiscontext)
              .translate("too many requests. Try again later".inCaps)+".") as String;
          break;
        case "operation-not-allowed":
          errorMessage = Text(AppLocalizations.of(thiscontext).translate(
              "signing in with Email and Password is not enabled".inCaps)+".") as String;
          break;
        default:
          errorMessage = Text(AppLocalizations.of(thiscontext)
              .translate("an undefined error happened".inCaps)+".") as String;
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    } else {
      Navigator.pushReplacement(
          thiscontext, MaterialPageRoute(builder: (context) => MyApp()));
      return Text(
              AppLocalizations.of(thiscontext).translate("sign in successful".inCaps)+".")
          as String;
    }
  }

  Future<String> signUp(
      {String email,
      String password,
      BuildContext thiscontext,
      bool isPatient}) async {
    String errorMessage;
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = Text(AppLocalizations.of(thiscontext)
                  .translate("your email address appears to be invalid".inCaps)+".")
              as String;
          break;
        case "weak-password":
          errorMessage = Text(AppLocalizations.of(thiscontext)
              .translate("your password is too small".inCaps)+".") as String;
          break;
        case "email-already-in-use":
          errorMessage = Text(AppLocalizations.of(thiscontext)
              .translate("this email has already been used".inCaps)+".") as String;
          break;
        case "user-disabled":
          errorMessage = Text(AppLocalizations.of(thiscontext)
              .translate("user with this email has been disabled".inCaps)+".") as String;
          break;
        case "too-many-requests":
          errorMessage = Text(AppLocalizations.of(thiscontext)
              .translate("too many requests".inCaps)+"."+AppLocalizations.of(thiscontext)
              .translate("try again later".inCaps)+".") as String;
          break;
        case "operation-not-allowed":
          errorMessage = Text(AppLocalizations.of(thiscontext).translate(
              "signing in with Email and Password is not enabled".inCaps)+".") as String;
          break;
        default:
          errorMessage = Text(AppLocalizations.of(thiscontext)
              .translate("an undefined error happened".inCaps)+".") as String;
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    } else {
      if (isPatient) {
        Navigator.pushReplacement(thiscontext,
            MaterialPageRoute(builder: (context) => RegisteringPage()));
      } else {
        Navigator.pushReplacement(thiscontext,
            MaterialPageRoute(builder: (context) => ConnectPatientPage()));
      }
      return Text(
              AppLocalizations.of(thiscontext).translate("sign in successful".inCaps))
          as String;
    }
  }
}
