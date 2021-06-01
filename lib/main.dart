import 'dart:ui';

import 'package:epilappsy/Authentication/SignInQR.dart';
import 'package:epilappsy/BrainAnswer/ba_api.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Pages/NavigationPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:epilappsy/Authentication/SignIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HealthCheck for Epilepsy',
            theme: ThemeData(
              canvasColor: mycolor,
              textTheme: TextTheme(
                bodyText1: TextStyle(
                    fontSize: 18.0,
                    letterSpacing: 1.5,
                    fontFamily: 'Lato',
                    color: Color(0xFF232D49)
                    //color: Colors.grey[800]),
                    ),
                headline1: TextStyle(
                    fontSize: 24.0,
                    letterSpacing: 2,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: mycolor
                    //color: Colors.grey[800]),
                    ),
              ),
              fontFamily: 'Lato',
              //brightness: Brightness.dark,
              scaffoldBackgroundColor: Color(0xFFFAFAFA), //Color(0xFFF1FAEE),
              primarySwatch: mycolor,
              backgroundColor: Color(0xFFFAFAFA), //Color(0xFFA8DADC),
              accentColor: Color(0xFF17c3b2), //Color(0xFFA8DADC),
              //canvasColor: Color(),
              unselectedWidgetColor: Color(0xFF232D49),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            // List all of the app's supported loca les here
            supportedLocales: [
              Locale('en', 'US'),
              Locale('pt', 'PT'),
            ],
            // These delegates make sure that the localization data for the proper language is loaded
            localizationsDelegates: [
              // THIS CLASS WILL BE ADDED LATER
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            // Returns a locale which will be used by the app

            /* localeResolutionCallback: (locale, supportedLocales) {
              // Check if the current device locale is supported
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }

              // If the locale of the device is not supported, use the first one
              // from the list (English, in this case).
              return supportedLocales.first;
            }, */
            initialRoute: '/',
            routes: {
              '/': (context) => AuthenticationWrapper(),
              '/login': (context) => SignIn(),
              '/loginQR': (context) => SignInQR(),
            });
    //home: AuthenticationWrapper()));
  }
}

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: BAApi.getLocalLoginToken(),
            builder: (BuildContext context, AsyncSnapshot snap) {
              if (snap == null ||
                  snap.connectionState != ConnectionState.done) {
                return const SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snap.hasData && snap.data != null && snap.data.isNotEmpty) {
                  checkIfPatientExists().then((value) {
                    if (!value) registerNewPatient();
                  });
                  print('token: ${BAApi.loginToken}');
                  BAApi.loginToken = snap.data;
                  print('token: ${BAApi.loginToken}');
                  Future.delayed(Duration(milliseconds: 100)).then(
                    (value) => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            NavigationPage(),
                      ),
                    ),
                  );
                } else {
                  Future.delayed(Duration(milliseconds: 100)).then(
                    (value) =>
                        Navigator.of(context).pushReplacementNamed("/login"),
                  );
                }
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}

/* class AuthenticationWrapper extends StatelessWidget {
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
} */

//    0xFF477B75

const MaterialColor mycolor = const MaterialColor(
  0xFFFAFAFA,
  //0xFFF1FAEE,

  const <int, Color>{
    50: Color.fromRGBO(71, 123, 117, .1),
    100: Color.fromRGBO(71, 123, 117, .2),
    200: Color.fromRGBO(71, 123, 117, .3),
    300: Color.fromRGBO(71, 123, 117, .4),
    400: Color.fromRGBO(71, 123, 117, .5),
    500: Color.fromRGBO(71, 123, 117, .6),
    600: Color.fromRGBO(71, 123, 117, .7),
    700: Color.fromRGBO(71, 123, 117, .8),
    800: Color.fromRGBO(71, 123, 117, .9),
    900: Color.fromRGBO(71, 123, 117, 1),
  },
);
