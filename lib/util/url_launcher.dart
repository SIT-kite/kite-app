import 'package:flutter/material.dart';
import 'package:kite/component/webview_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'logger.dart';

Future<void> launchUrlInBrowser(String url) async {
  Log.info('启动浏览器打开页面：$url');
  await launchUrlString(url);
}

Future<void> launchUrlInBuiltinWebView(
  BuildContext context,
  String url, {
  String? fixedTitle,
}) async {
  Log.info('开启内置WebView加载URL: $url');
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SimpleWebViewPage(
        initialUrl: url,
        fixedTitle: fixedTitle,
      ),
    ),
  );
}
