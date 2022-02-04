import 'package:kite/entity/edu/index.dart';

abstract class CourseEvaluationDao {
  Future<List<CourseToEvaluate>> getEvaluationList();
}
