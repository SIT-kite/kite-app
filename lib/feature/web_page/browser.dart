import 'package:flutter/material.dart';
import 'package:kite/component/webview_page.dart';

class BrowserPage extends StatelessWidget {
  final String initialUrl;
  const BrowserPage(this.initialUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleWebViewPage(
      initialUrl: initialUrl,
      showLoadInBrowser: true,
    );
  }
}
