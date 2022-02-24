/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/component/unsupported_platform_launch.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _reportUrlPrefix = 'http://xgfy.sit.edu.cn/h5/#/';
const _reportUrlIndex = _reportUrlPrefix + 'pages/index/index';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  @override
  _DailyReportPageState createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  void _onRefresh() async {
    final controller = await _controller.future;
    await controller.reload();
  }

  static Future<String> _getInjectJs() async {
    // TODO: 把 replace 完的 JS 缓存了
    final String username = StoragePool.authSetting.currentUsername ?? '';
    final String css = await rootBundle.loadString('assets/report/inject.css');
    final String js = await rootBundle.loadString('assets/report/inject.js');
    return js.replaceFirst('{{username}}', username).replaceFirst('{{injectCSS}}', css);
  }

  void _onPageFinished(String url) async {
    if (url.startsWith(_reportUrlPrefix)) {
      final controller = await _controller.future;
      final String js = await _getInjectJs();
      controller.runJavascript(js);
    }
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
          ? const UnsupportedPlatformUrlLauncher(_reportUrlIndex)
          : WebView(
              initialUrl: _reportUrlIndex,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageFinished: _onPageFinished,
            ),
    );
  }
}
