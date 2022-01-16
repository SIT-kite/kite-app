import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:kite/services/edu/src/edu_session.dart';
import 'package:kite/services/sso/sso.dart';

class SessionPool {
  static final Dio dio = initDioInstance();
  static final DefaultCookieJar _cookieJar = DefaultCookieJar();

  static DefaultCookieJar get cookieJar => _cookieJar;

  static final SsoSession ssoSession = SsoSession(dio: dio, jar: _cookieJar);
  static final EduSession eduSession = EduSession(ssoSession);

  static Dio initDioInstance() {
    Dio dio = Dio();
    // Add initialization code here.

    return dio;
  }
}
