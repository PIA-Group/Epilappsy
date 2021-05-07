import 'dart:io';
import 'package:epilappsy/BrainAnswer/ba_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:epilappsy/Pages/NavigationPage.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wakelock/wakelock.dart';
import 'package:vibration/vibration.dart';

class SignInQR extends StatefulWidget {
  const SignInQR();

  @override
  _SignInQRState createState() => _SignInQRState();
}

class _SignInQRState extends State<SignInQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;
  bool _processing = false;
  BAApi baApi;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    controller?.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      if (_processing) {
        controller.pauseCamera();
      } else {
        controller.resumeCamera();
      }
    }
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: FloatingActionButton(
          elevation: 0.0,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.close),
          backgroundColor: Colors.blue,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: <Widget>[
          Center(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  cutOutSize: width * 0.7,
                  borderColor: Colors.blue,
                  borderRadius: 10,
                  borderLength: 141,
                  borderWidth: 8),
            ),
          ),
          (_processing
              ? Center(
                  child: SizedBox(
                  height: 64,
                  width: 64,
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white),
                ))
              : Container(width: 0, height: 0)),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: width * 0.7,
              height: (height - width * 0.7) / 2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Aponte a câmara para o código QR",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 22),
                      ),
                    ),
                    /* SvgPicture.asset(
                      'assets/icons/qr-code.svg',
                      width: 48,
                      color: Colors.white54,
                    ), */
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        if (scanData != null && scanData.code != '') {
          print("found");
          if (scanData.toString() != qrText) {
            print(scanData);
            setState(
              () {
                qrText = scanData.toString();
                _processing = true;
              },
            );
            Vibration.vibrate(duration: 500);
            print("Login");
            BAApi.loginToken(scanData.toString()).then((String loginToken) {
              if (loginToken != null && loginToken.isNotEmpty) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => NavigationPage(loginToken),
                  ),
                  (_) => false,
                );
              } else {
                _errorDialog();
              }
            }).catchError((onError) {
              if (onError is SocketException) {
                _noConnectionDialog();
              } else {
                print(onError);
              }
            }).whenComplete(
              () {
                setState(
                  () {
                    _processing = false;
                  },
                );
              },
            );
          }
        }
      },
    );
  }

  void _errorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(milliseconds: 1500))
            .then((value) => Navigator.of(context).pop());
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: Container(
            padding: EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Text(
                    "Código inválido",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child:
                        Icon(Icons.error_outline, color: Colors.red, size: 64),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _noConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(milliseconds: 1500))
            .then((value) => Navigator.of(context).pop());
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.hardEdge,
          child: Container(
            padding: EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Text(
                    "Sem internet",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Icon(
                        Icons.signal_cellular_connected_no_internet_4_bar,
                        color: Colors.red,
                        size: 64),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}