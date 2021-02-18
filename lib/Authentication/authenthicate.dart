import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Authentication/RegisteringPage.dart';
import 'package:epilappsy/Caregiver/ConnectPatient.dart';
import 'package:flutter/material.dart';

import '../main.dart';

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
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    } else {
      Navigator.pushReplacement(
          thiscontext, MaterialPageRoute(builder: (context) => MyApp()));
      return 'Sign in Successful';
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
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "weak-password":
          errorMessage = "Your password is small.";
          break;
        case "email-already-in-use":
          errorMessage = "This email has already been used.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
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
      return 'Sign in Successful';
    }
  }
}
