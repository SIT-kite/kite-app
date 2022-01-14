import 'package:flutter/material.dart';
import 'package:kite/services/office/src/function.dart';
import 'package:kite/services/session_pool.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ApplyPage extends StatelessWidget {
  final SimpleFunction function;

  const ApplyPage(this.function, {Key? key}) : super(key: key);

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
    final String applyUrl = 'https://xgfy.sit.edu.cn/unifri-flow/WF/MyFlow.htm?ismobile=1&out=1&FK_Flow=${function.id}';

    return Scaffold(
      appBar: AppBar(
        title: Text(function.name),
      ),
      body: WebView(
        initialUrl: applyUrl,
        initialCookies: _loadCookieFromCookieJar(),
      ),
    );
  }
}
