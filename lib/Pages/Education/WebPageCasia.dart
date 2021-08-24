import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
//for the dictionaries

class WebViewContainer extends StatefulWidget {
  final url;
  final loc;
  WebViewContainer(this.url, this.loc);

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  var _loc;

  /* final Completer<WebViewController> _controller =
      Completer<WebViewController>(); */
  _WebViewContainerState(this._url);
  WebViewController _myController;
  bool _loadedPage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _loadedPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Builder(builder: (BuildContext context) {
        return new Stack(
          children: <Widget>[
            new WebView(
              initialUrl: _url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _myController = controller;
              },
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              onPageFinished: (url) {
                print('Page finished loading: $url');
                print(_loc);

                _myController.evaluateJavascript('self.find(' + _loc + ')');

                setState(() {
                  _loadedPage = true;
                });
              },
            ),
            _loadedPage == false
                ? new Center(
                    child: new CircularProgressIndicator(
                        backgroundColor: Colors.green),
                  )
                : new Container(),
          ],
        );
      }),
    );
  }

  /*Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            FutureBuilder<WebViewController>(
              future: _controller.future,
              builder: (context, AsyncSnapshot<WebViewController> controller) {
                if (controller.hasData) {
                  return Expanded(
                    child: WebView(
                      key: _key,
                      initialUrl: _url,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _mycontroller = controller;
                        //_controller.complete(webViewController);
                        //controller.data.evaluateJavascript(
                        //  'self.find("Participação na vida escolar")');
                      },
                      javascriptChannels: <JavascriptChannel>[
                    _toasterJavascriptChannel(context),
                  ].toSet(),
                  onPageFinished: (url){
                    print('Page finished loading: $url');

                    _myController.evaluateJavascript("javascript:(function() { " +
                        "var head = document.getElementsByClassName('top-bar js-top-bar top-bar__network _fixed')[0].style.display='none'; " +
                        "})()");

                    ),
                    //child: Text('Participação na vida escolar'),
                    // onPressed: () {
                    // controller.data.evaluateJavascript(
                    //   'self.find("Participação na vida escolar")');
                    // print(controller.data.evaluateJavascript(
                    //   'self.find("Participação na vida escolar")'));
                    //controller.data.scrollTo(x, y)
                    // });
                    // }
                  );
                } else {
                  return SizedBox(height: 40);
                }
              },
            ),
             Expanded(
                child: WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: _url,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
                // _controller.evaluateJavascript(
                //           'self.find("Participação na vida escolar")');
              },
            ))
          ],
        ));
  }*/
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        });
  }
}
