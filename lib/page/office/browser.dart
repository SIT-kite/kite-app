import 'package:flutter/material.dart';
import 'package:kite/component/unsupported_platform_launch.dart';
import 'package:kite/global/session_pool.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserPage extends StatelessWidget {
  final String functionName;
  final String url;

  const BrowserPage(this.functionName, this.url, {Key? key}) : super(key: key);

  List<WebViewCookie> _loadCookieFromCookieJar() {
    final cookieJar = SessionPool.cookieJar;
    final cookies = cookieJar.hostCookies['xgfy.sit.edu.cn']!['/unifri-flow/'];
    if (cookies != null) {
      List<WebViewCookie> cookieList = [];
      cookies.forEach((key, value) =>
          cookieList.add(WebViewCookie(name: key, value: value.cookie.value, domain: 'xgfy.sit.edu.cn')));
      return cookieList;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(functionName),
      ),
      body: UniversalPlatform.isDesktopOrWeb
          ? const UnsupportedPlatformUrlLauncher('http://ywb.sit.edu.cn/v1/#/', tip: '电脑端请连接校园网后在下方的浏览器中启动网页版')
          : WebView(
              initialUrl: url,
              initialCookies: _loadCookieFromCookieJar(),
            ),
    );
  }
}
