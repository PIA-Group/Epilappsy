import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
//for the dictionaries

class WebPage extends StatefulWidget {
  final String url;
  final String question;

  WebPage({Key key, this.question, @required this.url}) : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: appBarAll(context, [],
        //  widget.question), //context, [_bookmarkButton()], widget.question),
        body: FutureBuilder<WebViewController>(
            future: _controller.future,
            builder: (BuildContext context,
                AsyncSnapshot<WebViewController> controller) {
              if (controller.hasData) {
                return WebView(
                    initialUrl: widget.url,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            } //floatingActionButton: _bookmarkButton(),
            ));
  }
}
