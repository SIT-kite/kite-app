import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/service/edu/index.dart';
import 'package:kite/service/office/index.dart';
import 'package:kite/service/report/report.dart';
import 'package:kite/session/kite_session.dart';
import 'package:kite/session/library_session.dart';
import 'package:kite/session/sso/sso_session.dart';
import 'package:kite/util/logger.dart';
import 'package:path_provider/path_provider.dart';

class SessionPool {
  static String? httpProxy;
  static bool allowBadCertificate = true;

  static const String defaultUaString = 'kite-app';
  static String uaString = defaultUaString;

  // 持久化的CookieJar
  static late final PersistCookieJar _cookieJar;
  static PersistCookieJar get cookieJar => _cookieJar;

  static late Dio dio;
  static OfficeSession? officeSession;
  static ReportSession? reportSession;
  static late LibrarySession librarySession;
  static late SsoSession ssoSession;
  static late EduSession eduSession;
  static late KiteSession kiteSession;

  // 是否初始化过
  static bool _hasInit = false;
  static bool hasInit() => _hasInit;

  /// 初始化SessionPool
  static Future<void> init() async {
    Log.info("初始化SessionPool");

    if (!_hasInit) {
      final String homeDirectory = (await getApplicationDocumentsDirectory()).path;
      final FileStorage cookieStorage = FileStorage(homeDirectory + '/cookies/');
      // 初始化 cookie jar
      _cookieJar = PersistCookieJar(storage: cookieStorage);
    }
    // di o初始化完成后，才能初始化 UA
    dio = _initDioInstance();
    await _initUserAgentString();

    // 下面初始化一大堆session
    ssoSession = SsoSession(dio: dio, jar: _cookieJar);
    eduSession = EduSession(ssoSession);
    librarySession = LibrarySession(dio);
    kiteSession = KiteSession(dio, StoragePool.jwt);
    _hasInit = true;
  }

  static Dio _initDioInstance() {
    // 设置 HTTP 代理
    HttpOverrides.global = KiteHttpOverrides();

    Dio dio = Dio();
    // 添加拦截器
    dio.interceptors.add(CookieManager(_cookieJar));
    // 设置默认 User-Agent 字符串.
    dio.options.headers = {
      'User-Agent': uaString,
    };
    // 设置默认超时时间
    dio.options.connectTimeout = 10 * 1000;
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

class KiteHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    // 设置证书检查
    if (SessionPool.allowBadCertificate || StoragePool.network.useProxy || SessionPool.httpProxy != null) {
      client.badCertificateCallback = (cert, host, port) => true;
    }

    // 设置代理. 优先设置配置文件中的设置, 便于调试.
    if (SessionPool.httpProxy != null) {
      // 判断测试环境代理合法性
      // TODO: 检查代理格式
      if (SessionPool.httpProxy!.isNotEmpty) {
        // 可以
        Log.info('测试环境设置代理: ${SessionPool.httpProxy}');
        client.findProxy = (_) => 'PROXY ${SessionPool.httpProxy}';
      } else {
        // 不行
        Log.info('测试环境代理服务器为空或不合法，将不使用代理服务器');
      }
    } else if (StoragePool.network.useProxy && StoragePool.network.proxy.isNotEmpty) {
      Log.info('线上设置代理: ${SessionPool.httpProxy}');
      client.findProxy = (_) => 'PROXY ${StoragePool.network.proxy}';
    }
    return client;
  }
}
