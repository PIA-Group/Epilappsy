import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
//for the dictionaries

class RecordObject {
  final String question;
  final String url;

  RecordObject({this.question, this.url});
}

class WebPage extends StatefulWidget {
  final String url;
  final String question;

  ValueNotifier<List<RecordObject>> records;

  WebPage({Key key, this.records, this.question, @required this.url})
      : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarAll(context, [_bookmarkButton()],
            ''), //context, [_bookmarkButton()], widget.question),
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

  _bookmarkButton() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return Align(
            alignment: Alignment(0.8, 0.75),
            child: IconButton(
              icon: Icon(
                Icons.save,
                color: Theme.of(context).unselectedWidgetColor,
              ),
              onPressed: () async {
                var url = await controller.data.currentUrl();
                print(url);
                print(widget.records);
                setState(() {
                  widget.records.value
                      .add(RecordObject(question: widget.question, url: url));
                  widget.records.notifyListeners();
                  print(widget.records.value);
                });
                Navigator.pop(context);
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
