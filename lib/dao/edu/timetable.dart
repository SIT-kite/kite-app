import 'package:kite/entity/edu.dart';

abstract class TimetableDao {
  Future<List<Course>> getTimetable(SchoolYear schoolYear, Semester semester);
}
