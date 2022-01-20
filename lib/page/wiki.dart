import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/util/logger.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String _wikiUrl = 'https://kite.sunnysab.cn/wiki/';

class WikiPage extends StatefulWidget {
  const WikiPage({Key? key}) : super(key: key);

  @override
  _WikiPageState createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  void _onShare() async {
    Log.info('分享当前页');
  }

  static Future<String> _getInjectionJs() async {
    return (await rootBundle.loadString('assets/wiki/injection.js'));
  }

  void _onMenuClicked() async {
    final controller = await _controller.future;
    const String js = '''
      menuButton = document.querySelector('label.md-header__button:nth-child(2)');
      menuButton.click();
    ''';
    controller.runJavascript(js);
  }

  void _onPageFinished(String url) async {
    if (!url.startsWith(_wikiUrl)) {
      return;
    }
    final controller = await _controller.future;
    final String js = await _getInjectionJs();
    controller.runJavascript(js);
  }

  @override
  void initState() {
    super.initState();
    launch(_wikiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('上应 Wiki'),
        actions: [
          IconButton(
            onPressed: _onShare,
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: UniversalPlatform.isDesktopOrWeb
          ? const Center(
              child: Text('请在弹出浏览器中查阅Wiki'),
            )
          : WebView(
              initialUrl: _wikiUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageStarted: _onPageFinished,
            ),
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.menu), onPressed: _onMenuClicked),
    );
  }
}
