import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

//for the dictionaries
import '../app_localizations.dart';

class ConnectPage extends StatefulWidget {
  final Widget child;

  ConnectPage({Key key, this.child}) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context).translate(
            'To connect to your caregiver, have him scan this QR Code'),
            textAlign: TextAlign.center,
          ),
          QrImage(
            data: FirebaseAuth.instance.currentUser.uid,
            version: QrVersions.auto,
            size: 200.0,
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    ));
  }
}
