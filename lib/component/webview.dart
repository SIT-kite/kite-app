import 'package:flutter/material.dart';
import 'package:kite/util/logger.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'unsupported_platform_launch.dart';

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
class MyWebView extends StatefulWidget {
  final String? initialUrl;
  final String? injectJs;
  final WebViewCreatedCallback? onWebViewCreated;
  final PageStartedCallback? onPageStarted;
  final PageFinishedCallback? onPageFinished;
  final JavascriptMode javascriptMode;
  const MyWebView({
    Key? key,
    this.initialUrl,
    this.injectJs,
    this.onWebViewCreated,
    this.onPageStarted,
    this.onPageFinished,
    this.javascriptMode = JavascriptMode.unrestricted, // js支持默认启用
  }) : super(key: key);

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  @override
  Widget build(BuildContext context) {
    return UniversalPlatform.isDesktopOrWeb
        ? UnsupportedPlatformUrlLauncher(widget.initialUrl ?? '')
        : WebView(
            initialUrl: widget.initialUrl,
            javascriptMode: widget.javascriptMode,
            onWebViewCreated: (WebViewController webViewController) {
              Log.info('WebView已创建，已获取到controller');

              if (widget.injectJs != null) {
                webViewController.runJavascript(widget.injectJs!);
              }
              if (widget.onWebViewCreated != null) {
                widget.onWebViewCreated!(webViewController);
              }
            },
            onPageStarted: (String url) {
              Log.info('开始加载url: $url');
              if (widget.onPageStarted != null) {
                widget.onPageStarted!(url);
              }
            },
            onPageFinished: (String url) {
              Log.info('url加载完毕: $url');
              if (widget.onPageFinished != null) {
                widget.onPageFinished!(url);
              }
            },
          );
  }
}
