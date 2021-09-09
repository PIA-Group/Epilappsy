import 'package:casia/Database/database.dart';
import 'package:casia/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
//for the dictionaries

class RecordObject {
  final String question;
  final String url;

  RecordObject({this.question, this.url});

  Map<String, String> toJson() {
    return {
      'question': this.question,
      'url': this.url,
    };
  }
}

class WebPage extends StatefulWidget {
  final String url;
  final String question;

  final ValueNotifier<List<RecordObject>> records;

  WebPage({Key key, this.records, this.question, @required this.url})
      : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    print('url ${widget.url}');
    return Scaffold(
      body:
          ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        Container(
            color: DefaultColors.mainColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: DefaultColors.backgroundColor,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  _bookmarkButton()
                ])),
        FutureBuilder<WebViewController>(
          future: _controller.future,
          builder: (context, AsyncSnapshot<WebViewController> controller) {
            if (controller.hasData) {
              //Future.delayed(Duration(seconds: 2)).then((value) {
              // controller.data.evaluateJavascript('self.find("$loc")');
              //});
              print(controller.data);
              return Container();
            } else
              return CircularProgressIndicator();
          },
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 2,
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
            onWebViewCreated: (WebViewController webViewController) {
              setState(() {
                _controller.complete(webViewController);
              });
            },
          ),
        ),
      ]),
    );
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
                Icons.save_rounded,
                color: DefaultColors.backgroundColor,
              ),
              onPressed: () async {
                var url = await controller.data.currentUrl();
                print(url);
                setState(() {
                  widget.records.value
                      .add(RecordObject(question: widget.question, url: url));
                  widget.records.notifyListeners();
                  print(widget.records.value);
                  saveQuestions(
                      RecordObject(question: widget.question, url: url));
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
