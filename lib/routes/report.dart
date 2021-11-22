import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  @override
  _DailyReportPageState createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('报不完的体温上报'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              var controller = await _controller.future;
              await controller.reload();
            },
            child: const Icon(Icons.refresh),
          )
        ],
      ),
      body: WebView(
        initialUrl: 'http://xgfy.sit.edu.cn/h5/#',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          print("WebView is loading (progress : $progress%)");
        },
        onPageFinished: (String url) async {
          print('OnPageFinished: $url');
          var controller = await _controller.future;
          controller.runJavascript(
              r"document.querySelector('.flex-direction > uni-view:nth-child(1)').textContent='上海应用技术大学小风筝研发中心'");
          controller.runJavascript(
              r"document.querySelector('.flex-direction > uni-view:nth-child(2)').textContent='机协软件 联合开发'");
        },
      ),
    );
  }
}
