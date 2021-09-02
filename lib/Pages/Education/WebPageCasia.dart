import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  _WebViewContainerState(this._url, this._loc);

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
              return SizedBox(height: 20);
            } else
              return SizedBox(height: 20);
          },
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: WebView(
            initialUrl: _url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              setState(() {
                _controller.complete(webViewController);
              });
            },
          ),
        )
      ],
    ));
  }
}
