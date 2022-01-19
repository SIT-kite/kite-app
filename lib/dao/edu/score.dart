import 'package:kite/entity/edu.dart';

abstract class ScoreDao {
  Future<List<Score>> getScoreList(SchoolYear year, Semester semester);

  Future<List<ScoreDetail>> getScoreDetail(String classId, SchoolYear schoolYear, Semester semester);
}
