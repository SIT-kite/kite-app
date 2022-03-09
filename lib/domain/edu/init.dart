import 'package:hive/hive.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/util/hive_register_adapter.dart';

import 'dao/index.dart';
import 'entity/timetable.dart';
import 'service/index.dart';
import 'storage/timetable.dart';

class EduInitializer {
  static late CourseEvaluationDao courseEvaluation;
  static late ExamDao exam;
  static late ScoreDao score;
  static late TimetableDao timetable;

  static late TimetableStorageDao timetableStorage;

  /// 初始化教务相关的service
  static Future<void> init(ASession session) async {
    registerAdapter(CourseAdapter());

    courseEvaluation = CourseEvaluationService(session);
    exam = ExamService(session);
    score = ScoreService(session);
    timetable = TimetableService(session);

    final courseBox = await Hive.openBox<dynamic>('course');
    timetableStorage = TimetableStorage(courseBox);
  }
}
