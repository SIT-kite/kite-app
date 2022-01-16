import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPageGamePage extends StatefulWidget {
  final String url;
  const WebPageGamePage(this.url, {Key? key}) : super(key: key);

  @override
  _WebPageGamePageState createState() => _WebPageGamePageState();
}

class _WebPageGamePageState extends State<WebPageGamePage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
