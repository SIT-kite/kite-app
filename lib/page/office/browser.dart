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
