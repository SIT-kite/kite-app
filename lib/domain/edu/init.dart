import 'package:kite/abstract/abstract_session.dart';

import 'dao/index.dart';
import 'service/index.dart';

class EduInitializer {
  static late CourseEvaluationDao courseEvaluation;
  static late ExamDao exam;
  static late ScoreDao score;
  static late TimetableDao timetable;

  /// 初始化教务相关的service
  static void init(ASession session) {
    courseEvaluation = CourseEvaluationService(session);
    exam = ExamService(session);
    score = ScoreService(session);
    timetable = TimetableService(session);
  }
}
