import 'package:flutter/material.dart';
import 'package:kite/component/webview.dart';

class SimpleWebViewPage extends StatefulWidget {
  final String initialUrl;
  const SimpleWebViewPage(this.initialUrl, {Key? key}) : super(key: key);

  @override
  _SimpleWebViewPageState createState() => _SimpleWebViewPageState();
}

class _SimpleWebViewPageState extends State<SimpleWebViewPage> {
  String title = '无标题页面';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: MyWebView(
          initialUrl: widget.initialUrl,
          onWebViewCreated: (controller) async {
            title = (await controller.getTitle()) ?? '无标题页面';
            setState(() {});
          }),
    );
  }
}
