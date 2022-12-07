import '../entity/exam.dart';
import '../storage/exam.dart';

import '../dao/exam.dart';
import '../using.dart';

class ExamCache extends ExamDao {
  final ExamDao from;
  final ExamStorage to;
  Duration expiration;

  ExamCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  @override
  Future<List<ExamEntry>> getExamList(SchoolYear schoolYear, Semester semester) async {
    final cacheKey = to.box.exams.make(ExamStorage.composeExamsKey(schoolYear, semester));
    if(cacheKey.needRefresh(after: expiration)){
      final res = await from.getExamList(schoolYear, semester);
      to.setExamList(schoolYear, semester, res);
      return res;
    } else {
      return to.getExamList(schoolYear, semester);
    }
  }
}
