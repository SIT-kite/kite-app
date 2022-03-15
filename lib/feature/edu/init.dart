import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';
import 'package:kite/feature/edu/exam/init.dart';
import 'package:kite/feature/edu/score/init.dart';
import 'package:kite/feature/edu/timetable/init.dart';
import 'package:kite/session/sso/index.dart';

import 'edu_session.dart';

class EduInitializer {
  static late CookieJar cookieJar;
  static late EduSession eduSession;

  /// 初始化教务相关的service
  static Future<void> init({
    required SsoSession ssoSession,
    required CookieJar cookieJar,
    required Box<dynamic> timetableBox,
  }) async {
    EduInitializer.cookieJar = cookieJar;
    eduSession = EduSession(ssoSession);
    ExamInitializer.init(eduSession);
    ScoreInitializer.init(eduSession);
    TimetableInitializer.init(eduSession: eduSession, timetableBox: timetableBox);
  }
}
