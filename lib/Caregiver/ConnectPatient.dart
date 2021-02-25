import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:epilappsy/Database/database.dart';

class ConnectPatientPage extends StatefulWidget {
  final Widget child;

  ConnectPatientPage({Key key, this.child}) : super(key: key);

  @override
  _ConnectPatientPageState createState() => _ConnectPatientPageState();
}

class _ConnectPatientPageState extends State<ConnectPatientPage> {
  String barcode = "";
  String uid = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitleCG(context),
          backgroundColor: Color.fromRGBO(71, 98, 123, 1),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Please scan the code of the person you will be monitoring.',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side:
                            BorderSide(color: Color.fromRGBO(71, 98, 123, 1))),
                    color: Color.fromRGBO(71, 98, 123, 1),
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: () => scan(),
                    icon: Icon(Icons.qr_code),
                    label: const Text('START SCAN')),
              ),
            ],
          ),
        ));
  }

  Future scan() async {
    try {
      await FlutterBarcodeScanner.scanBarcode(
              "#ff6666", "Cancel", false, ScanMode.DEFAULT)
          .then((value) {
        try {
          print(value);
          addPatient2Caregiver(uid, value);
          setState(() => this.barcode = 'Patient successfully added!');
          Navigator.pop(context);
        } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      setState(() =>
          this.barcode = 'Something went wrong... Verify camera permissions.');
    }
  }
}
