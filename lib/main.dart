import 'dart:ui';
import 'package:casia/Authentication/SignInQR.dart';
import 'package:casia/BrainAnswer/ba_api.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/Pages/NavigationPage.dart';
import 'package:casia/design/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:casia/Authentication/SignIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CASIA',
        theme: ThemeData(
          canvasColor: mycolor,
          textTheme: TextTheme(
            bodyText1: TextStyle(
              fontSize: 18.0,
              letterSpacing: 1.5,
              fontFamily: 'Lato',
              color: Colors.white,
            ),
            bodyText2: TextStyle(
              fontSize: 18.0,
              letterSpacing: 1.5,
              fontFamily: 'Lato',
              color: DefaultColors.textColorOnLight,
            ),
            headline1: TextStyle(
                fontSize: 40.0,
                letterSpacing: 1.5,
                fontFamily: 'Canter',
                fontWeight: FontWeight.bold,
                color: mycolor),
            headline2: TextStyle(
                fontSize: 24.0,
                letterSpacing: 1.2,
                fontFamily: 'Lato',
                fontWeight: FontWeight.normal,
                color: DefaultColors.textColorOnDark
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
          '/navigation': (contex) => NavigationPage(),
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
  void initState() {
    super.initState();
    signInAnonymously();
  }

  void signInAnonymously() {
    try {
      _auth.signInAnonymously();
      print('Signed in anonymously on Firebase');
    } catch (e) {
      print(e);
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                        builder: (context) => NavigationPage(),
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

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .split(" ")
      .map((str) => '${str[0].toUpperCase()}${str.substring(1)}')
      .join(" ");
}

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
