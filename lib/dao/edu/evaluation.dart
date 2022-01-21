import 'package:kite/entity/edu.dart';

abstract class CourseEvaluationDao {
  Future<List<CourseToEvaluate>> getEvaluationList();
}
