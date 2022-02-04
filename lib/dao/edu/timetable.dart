import 'package:kite/entity/edu/index.dart';

abstract class TimetableDao {
  Future<List<Course>> getTimetable(SchoolYear schoolYear, Semester semester);
}

abstract class TimetableStorageDao extends TimetableDao {
  void add(Course item);

  void addAll(List<Course> courseList);

  void delete(String record);

  void deleteAll();

  bool isEmpty();

  bool clear();
}
