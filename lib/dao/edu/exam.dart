import 'package:kite/entity/edu/index.dart';

abstract class ExamDao {
  Future<List<ExamRoom>> getExamList(SchoolYear schoolYear, Semester semester);
}
