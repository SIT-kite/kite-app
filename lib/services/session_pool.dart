import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';
import 'package:kite/services/edu/edu_session.dart';
import 'package:kite/services/library/library_session.dart';
import 'package:kite/services/sso/sso.dart';

const String? httpProxy = null;
const bool allowBadCertificate = true;

class SessionPool {
  static const String defaultUaString = 'kite-app';
  static String uaString = defaultUaString;

  static final Dio dio = initDioInstance();
  static final DefaultCookieJar _cookieJar = DefaultCookieJar();

  static DefaultCookieJar get cookieJar => _cookieJar;

  static final SsoSession ssoSession = SsoSession(dio: dio, jar: _cookieJar);
  static final EduSession eduSession = EduSession(ssoSession);
  static final LibrarySession librarySession = LibrarySession(dio);

  static Dio initDioInstance() {
    Dio dio = Dio();

    // 添加拦截器
    dio.interceptors.add(CookieManager(_cookieJar));

    /// 创建 Http client 时的回调.
    HttpClient onHttpClientCreate(HttpClient client) {
      // 设置证书检查
      if (allowBadCertificate || httpProxy != null) {
        client.badCertificateCallback = (cert, host, port) => true;
      }
      // 设置代理
      if (httpProxy != null) {
        client.findProxy = (_) => 'PROXY $httpProxy';
      }
      return client;
    }

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = onHttpClientCreate;

    // 设置默认 User-Agent 字符串.
    dio.options.headers = {
      'User-Agent': uaString,
    };
    return dio;
  }

  static void initUserAgentString() {
    Future.delayed(Duration.zero, () async {
      await FlutterUserAgent.init();
      uaString = FlutterUserAgent.webViewUserAgent ?? defaultUaString;
      // 更新 dio 设置的 user-agent 字符串
      dio.options.headers['User-Agent'] = uaString;
    });
  }
}
