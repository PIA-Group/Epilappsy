import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:epilappsy/Authentication/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Authentication/WelcomePage.dart';
import 'Authentication/authenthicate.dart';

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
            // List all of the app's supported locales here
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
