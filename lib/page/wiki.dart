/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/component/unsupported_platform_launch.dart';
import 'package:kite/util/logger.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String _wikiUrl = 'https://cdn.kite.sunnysab.cn/wiki/';

class WikiPage extends StatefulWidget {
  const WikiPage({Key? key}) : super(key: key);

  @override
  _WikiPageState createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  void _onShare() async {
    Log.info('分享当前页面');
  }

  static Future<String> _getInjectionJs() async {
    return (await rootBundle.loadString('assets/wiki/injection.js'));
  }

  void _onMenuClicked() async {
    final controller = await _controller.future;
    const String js = '''
      menuButton = document.querySelector('label.md-header__button:nth-child(2)');
      menuButton !== null && menuButton.click();
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
          ? const UnsupportedPlatformUrlLauncher(_wikiUrl)
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
