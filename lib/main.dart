import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:epilappsy/Authentication/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Authentication/WelcomePage.dart';
import 'Authentication/authenthicate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
          )
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HealthCheck for Epilepsy',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: AuthenticationWrapper()));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  // if the user is authenticated - opens WelcomePage (that check if user is a patient or caregiver)
  // else - opens SignIn page
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    print("user ID: $firebaseUser");

    if (firebaseUser != null) {
      return WelcomePage();
    }
    return SignIn();
  }
}
