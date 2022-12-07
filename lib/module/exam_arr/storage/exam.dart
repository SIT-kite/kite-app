import 'package:kite/cache/box.dart';

import '../dao/exam.dart';
import '../entity/exam.dart';
import '../using.dart';

class ExamStorageBox with CachedBox {
  static const _examArrangementNs = "/exam_arr";
  @override
  final Box box;
  late final exams = Namespace<List<ExamEntry>>(_examArrangementNs);

  ExamStorageBox(this.box);
}

class ExamStorage extends ExamDao {
  final ExamStorageBox box;

  ExamStorage(Box<dynamic> hive) : box = ExamStorageBox(hive);

  static String composeExamsKey(SchoolYear schoolYear, Semester semester) {
    return "$schoolYear/$semester";
  }

  @override
  Future<List<ExamEntry>> getExamList(SchoolYear schoolYear, Semester semester) async {
    final cacheKey = box.exams.make(composeExamsKey(schoolYear, semester));
    return cacheKey.value ?? [];
  }

  void setExamList(SchoolYear schoolYear, Semester semester, List<ExamEntry> exams) {
    final cacheKey = box.exams.make(composeExamsKey(schoolYear, semester));
    cacheKey.value = exams;
  }
}
