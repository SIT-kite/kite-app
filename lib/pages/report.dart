import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/storage/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  @override
  _DailyReportPageState createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  void _onRefresh() async {
    var controller = await _controller.future;
    await controller.reload();
  }

  Future<String> _queryLocalUser() async => AuthStorage(await SharedPreferences.getInstance()).username;

  static Future<String> _getInjectionJs(String userName) async {
    return (await rootBundle.loadString('assets/dailyReport/injection.js')).replaceFirst('{username}', userName);
  }

  void _onPageFinished(String url) async {
    if (url != 'http://xgfy.sit.edu.cn/h5/#/') {
      return;
    }
    final controller = await _controller.future;
    final String user = await _queryLocalUser();
    final String js = await _getInjectionJs(user);
    controller.runJavascript(js);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('体温上报'),
        actions: [
          IconButton(
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: WebView(
        initialUrl: 'http://xgfy.sit.edu.cn/h5/#/pages/index/index',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onPageFinished: _onPageFinished,
      ),
    );
  }
}
