import 'package:cookie_jar/cookie_jar.dart';
import 'package:kite/services/edu/src/edu_session.dart';
import 'package:kite/services/sso/sso.dart';

class SessionPool {
  static final DefaultCookieJar cookieJar = DefaultCookieJar();
  static final Session ssoSession = Session(jar: cookieJar);
  static final EduSession eduSession = EduSession(ssoSession);
}
