import 'package:epilappsy/Database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          email: email.trim(), password: password.trim());
    } catch (error) {
      print(error.code);
      switch (error.code) {
        case "invalid-email":
          errorMessage = AppLocalizations.of(thiscontext)
                  .translate('Your email address appears to be invalid.');
          break;
        case "wrong-password":
          errorMessage = AppLocalizations.of(thiscontext)
              .translate('Your password is invalid.');
          break;
        case "user-not-found":
          errorMessage = AppLocalizations.of(thiscontext)
              .translate("User with this email doesn't exist.");
          break;
        case "user-disabled":
          errorMessage = AppLocalizations.of(thiscontext)
              .translate("User with this email has been disabled.");
          break;
        case "too-many-requests":
          errorMessage = AppLocalizations.of(thiscontext)
              .translate("Too many requests. Try again later.");
          break;
        case "operation-not-allowed":
          errorMessage = AppLocalizations.of(thiscontext).translate(
              "Signing in with Email and Password is not enabled.");
          break;
        default:
          errorMessage = AppLocalizations.of(thiscontext)
              .translate("An undefined error happened.");
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    } else {
      Navigator.pushReplacement(
          thiscontext, MaterialPageRoute(builder: (context) => MyApp()));
      return Text(
              AppLocalizations.of(thiscontext).translate("Sign in successful"))
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
          email: email.trim(), password: password.trim());
    } catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = AppLocalizations.of(thiscontext)
                  .translate("Your email address appears to be invalid.");
          break;
        case "weak-password":
          errorMessage = AppLocalizations.of(thiscontext)
              .translate("Your password is too small.");
          break;
        case "email-already-in-use":
          errorMessage = AppLocalizations.of(thiscontext)
              .translate("This email has already been used.");
          break;
        case "user-disabled":
          errorMessage = AppLocalizations.of(thiscontext)
              .translate("User with this email has been disabled.");
          break;
        case "too-many-requests":
          errorMessage = AppLocalizations.of(thiscontext)
              .translate("Too many requests. Try again later.");
          break;
        case "operation-not-allowed":
          errorMessage = AppLocalizations.of(thiscontext).translate(
              "Signing in with Email and Password is not enabled.");
          break;
        default:
          errorMessage = AppLocalizations.of(thiscontext)
              .translate("An undefined error happened.");
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    } else {
      if (isPatient) {
        registerNewPatient();
        Navigator.pushReplacement(
          thiscontext, MaterialPageRoute(builder: (context) => MyApp()));
        /* Navigator.pushReplacement(thiscontext,
            MaterialPageRoute(builder: (context) => RegisteringPage())); */
      } else {
        registerNewCaregiver();
        Navigator.pushReplacement(
          thiscontext, MaterialPageRoute(builder: (context) => MyApp()));
        /* Navigator.pushReplacement(thiscontext,
            MaterialPageRoute(builder: (context) => ConnectPatientPage())); */
      }
      return Text(
              AppLocalizations.of(thiscontext).translate("Sign in Successful"))
          as String;
    }
  }
}
