import 'package:hive/hive.dart';
import 'package:kite/dao/edu/timetable.dart';
import 'package:kite/entity/edu.dart';

class CourseStorage implements TimetableStorageDao {
  final Box<Course> box;

  const CourseStorage(this.box);

  @override
  void add(Course item) {
    box.put(item.courseId.toString() + item.week.toString() + item.timeIndex.toString(), item);
  }

  @override
  void addAll(List<Course> courseList) {
    courseList.forEach((item) {
      box.put(item.courseId.toString() + item.week.toString() + item.timeIndex.toString(), item);
    });
  }

  @override
  void delete(String record) {
    box.delete(record.hashCode);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys.map((e) => e.hashCode));
  }

  @override
  bool isEmpty() {
    return box.isEmpty;
  }

  @override
  bool clear() {
    box.clear();
    return true;
  }

  @override
  Future<List<Course>> getTimetable(SchoolYear schoolYear, Semester semester) async {
    var result = box.values.toList();
    return result;
  }
}
