import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/feature/edu/score/service/evaluation.dart';

import 'dao/evaluation.dart';
import 'dao/score.dart';
import 'service/score.dart';

class ScoreInitializer {
  static late ScoreDao scoreService;
  static late CourseEvaluationDao courseEvaluationService;

  static void init(ASession eduSession) {
    scoreService = ScoreService(eduSession);
    courseEvaluationService = CourseEvaluationService(eduSession);
  }
}
