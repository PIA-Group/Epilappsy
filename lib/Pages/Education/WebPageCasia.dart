import 'dart:async';

import 'package:casia/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
//for the dictionaries

class WebViewContainer extends StatefulWidget {
  final url;
  final loc;
  WebViewContainer(this.url, this.loc);

  @override
  createState() => _WebViewContainerState(this.url, this.loc);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  var _loc;
  //final _key = UniqueKey();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  _WebViewContainerState(this._url, this._loc);
  //AsyncSnapshot<WebViewController> _myController;
  //bool _loadedPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        FutureBuilder<WebViewController>(
          future: _controller.future,
          builder: (context, AsyncSnapshot<WebViewController> controller) {
            if (controller.hasData) {
              Future.delayed(Duration(seconds: 2)).then((value) {
                controller.data.evaluateJavascript('self.find("$_loc")');
              });
              return Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: Container(
                  color: DefaultColors.mainColor,
                  child: TextButton(
                      //clipBehavior: Clip.antiAlias,
                      child: Row(children: [
                        Expanded(
                            child: Text(_loc,
                                style: Theme.of(context).textTheme.headline2)),
                        Padding(
                            padding: EdgeInsets.only(
                                right:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Icon(Icons.forward,
                                color: DefaultColors.textColorOnDark, size: 40))
                      ]),
                      onPressed: () {
                        controller.data
                            .evaluateJavascript('self.find("$_loc")');
                      }),
                ),
              );
            }

            return SizedBox(height: 20);
          },
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: WebView(
            initialUrl: _url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            
            
          ),
        )
      ],
    ));
  }

  /* JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        });
  } */
}
