import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/component/unsupported_platform_launch.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _reportIndexUrl = 'http://xgfy.sit.edu.cn/h5/#/pages/index/index';

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

  String _queryLocalUser() => StoragePool.authSetting.currentUsername ?? '';

  static Future<String> _getInjectionJs(String userName) async {
    return (await rootBundle.loadString('assets/report/injection.js')).replaceFirst('{username}', userName);
  }

  void _onPageFinished(String url) async {
    if (url != 'http://xgfy.sit.edu.cn/h5/#/') {
      return;
    }
    final controller = await _controller.future;
    final String user = _queryLocalUser();
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
      body: UniversalPlatform.isDesktopOrWeb
          ? const UnsupportedPlatformUrlLauncher(_reportIndexUrl)
          : WebView(
              initialUrl: _reportIndexUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageFinished: _onPageFinished,
            ),
    );
  }
}
