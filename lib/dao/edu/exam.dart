import 'package:kite/entity/edu.dart';

abstract class ExamDao {
  Future<List<ExamRoom>> getExamList(SchoolYear schoolYear, Semester semester);
}
