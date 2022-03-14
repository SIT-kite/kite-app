import 'package:kite/abstract/abstract_session.dart';

import 'dao/exam.dart';
import 'service/exam.dart';

class ExamInitializer {
  static late ExamDao examService;
  static void init(ASession eduSession) {
    examService = ExamService(eduSession);
  }
}
