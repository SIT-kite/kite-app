import 'package:kite/entity/edu.dart';

abstract class TimetableDao {
  Future<List<Course>> getTimetable(SchoolYear schoolYear, Semester semester);
}

abstract class TimetableStorageDao extends TimetableDao {
  void add(Course item);
  void delete(String record);
  void deleteAll();
}
