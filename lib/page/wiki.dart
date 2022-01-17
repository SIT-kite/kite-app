import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    print('分享当前页');
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
    if (!url.startsWith('https://kite.sunnysab.cn/wiki/')) {
      return;
    }
    final controller = await _controller.future;
    final String js = await _getInjectionJs();
    controller.runJavascript(js);
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
      body: WebView(
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
