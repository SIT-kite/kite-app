import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:kite/services/office/office.dart';

class ApplyPage extends StatelessWidget {
  final String functionId;

  const ApplyPage(this.functionId);

  // List<WebViewCookie>  _loadCookieFromCookieJar(Dio) {
  //   final cookieJar = PersistCookieJar();
  //   final cookies = cookieJar.domainCookies['xgfy.sit.edu.cn'];
  //
  //   if (cookies == null) {
  //     return <WebViewCookie>[];
  //   }
  //   cookies.entries.map((cookie) => cookie[]);
  // }
  @override
  Widget build(BuildContext context) {
    final String applyUrl = 'https://xgfy.sit.edu.cn/unifri-flow/WF/MyFlow.htm?ismobile=1&out=1&FK_Flow=$functionId';

    return Scaffold(
      appBar: AppBar(
        title: const Text('办公'),
      ),
      body: WebView(
        initialUrl: applyUrl,
        initialCookies: [],
      ),
    );
  }
}
