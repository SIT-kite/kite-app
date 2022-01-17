import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:kite/service/edu.dart';
import 'package:kite/service/library/library_session.dart';
import 'package:kite/service/sso.dart';
import 'package:kite/util/logger.dart';

const String? httpProxy = null;
const bool allowBadCertificate = true;

class SessionPool {
  static const String defaultUaString = 'kite-app';
  static String uaString = defaultUaString;

  static final DefaultCookieJar _cookieJar = DefaultCookieJar();
  static DefaultCookieJar get cookieJar => _cookieJar;

  static late Dio dio;
  static late SsoSession ssoSession;
  static late EduSession eduSession;
  static late LibrarySession librarySession;

  static Future<void> init() async {
    Log.info("初始化SessionPool");
    // 只有初始化完dio后才能初始化UA
    dio = _initDioInstance();
    await _initUserAgentString();

    // 下面初始化一大堆session
    ssoSession = SsoSession(dio: dio, jar: _cookieJar);
    eduSession = EduSession(ssoSession);
    librarySession = LibrarySession(dio);
  }

  static Dio _initDioInstance() {
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

    // 设置默认超时时间
    dio.options.connectTimeout = 5 * 1000;
    dio.options.sendTimeout = 60 * 1000;
    dio.options.receiveTimeout = 60 * 1000;
    return dio;
  }

  static Future<void> _initUserAgentString() async {
    try {
      // 如果非IOS/Android，则该函数将抛异常
      await FkUserAgent.init();
      uaString = FkUserAgent.webViewUserAgent ?? defaultUaString;
      // 更新 dio 设置的 user-agent 字符串
      dio.options.headers['User-Agent'] = uaString;
    } catch (e) {
      // Desktop端将进入该异常
      // TODO: 自定义UA
      dio.options.headers['User-Agent'] = uaString;
    }
  }
}
