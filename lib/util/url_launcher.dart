import 'package:flutter/material.dart';
import 'package:kite/component/webview_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logger.dart';

Future<void> launchUrl(String url) async {
  Log.info('开启浏览器加载URL: $url');
  if (!await launch(url)) {
    throw 'Could not launch $url';
  }
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
