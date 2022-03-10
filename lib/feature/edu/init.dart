import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';
import 'package:kite/abstract/abstract_session.dart';

import 'dao/index.dart';
import 'service/index.dart';
import 'storage/timetable.dart';

class EduInitializer {
  static late CourseEvaluationDao courseEvaluation;
  static late ExamDao exam;
  static late ScoreDao score;
  static late TimetableDao timetable;
  static late TimetableStorageDao timetableStorage;

  static late CookieJar cookieJar;
  static late EduSession eduSession;

  /// 初始化教务相关的service
  static Future<void> init({
    required ASession ssoSession,
    required CookieJar cookieJar,
    required Box<dynamic> timetableBox,
  }) async {
    EduInitializer.cookieJar = cookieJar;
    eduSession = EduSession(ssoSession);

    courseEvaluation = CourseEvaluationService(eduSession);
    exam = ExamService(eduSession);
    score = ScoreService(eduSession);
    timetable = TimetableService(eduSession);

    timetableStorage = TimetableStorage(timetableBox);
  }
}
