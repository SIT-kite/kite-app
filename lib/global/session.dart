import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:kite/domain/edu/service/index.dart';
import 'package:kite/domain/kite/kite_session.dart';
import 'package:kite/domain/office/service/index.dart';
import 'package:kite/domain/report/report_session.dart';
import 'package:kite/domain/sc/sc_session.dart';
import 'package:kite/session/sso/sso_session.dart';
import 'package:kite/setting/init.dart';

class Session {
  static OfficeSession officeSession;
  static ReportSession reportSession;
  static late SsoSession ssoSession;
  static late EduSession eduSession;
  static late ScSession scSession;
  static late KiteSession kiteSession;

  static void init(Dio dio, CookieJar cookieJar) {
    // 下面初始化一大堆session
    ssoSession = SsoSession(dio: dio, jar: cookieJar);
    scSession = ScSession(ssoSession);
    eduSession = EduSession(ssoSession);
    kiteSession = KiteSession(dio, SettingInitializer.jwt);
  }
}
