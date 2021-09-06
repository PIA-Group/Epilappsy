import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  WebViewContainer();

  @override
  createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  String tipOfDay = 'tip' + DateTime.now().day.toString();

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
          future: getDailyTip(tipOfDay),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              print('waiting');
              return CircularProgressIndicator();
            } else {
              print(snapshot.data);
              String loc = snapshot.data['key_pt'];
              String url = snapshot.data['url_pt'];
              return ListView(shrinkWrap: true, children: [
                FutureBuilder<WebViewController>(
                  future: _controller.future,
                  builder:
                      (context, AsyncSnapshot<WebViewController> controller) {
                    if (controller.hasData) {
                      Future.delayed(Duration(seconds: 2)).then((value) {
                        controller.data.evaluateJavascript('self.find("$loc")');
                      });
                      print(controller.data);
                      return Container();
                    } else
                      return CircularProgressIndicator();
                  },
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: WebView(
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      setState(() {
                        _controller.complete(webViewController);
                      });
                    },
                  ),
                ),

                
              ]);
            }
          }),
    );
  }

  Future<dynamic> getDailyTip(String tipOfDay) async {
    var dailyTip = await FirebaseFirestore.instance
        .collection('daily-tips')
        .doc(tipOfDay)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      } else {
        print('Document does not exist on the database');
      }
    });
    return dailyTip;
  }
}
