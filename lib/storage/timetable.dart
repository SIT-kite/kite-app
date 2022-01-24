import 'package:hive/hive.dart';
import 'package:kite/dao/edu/timetable.dart';
import 'package:kite/entity/edu.dart';

class CourseStorage implements TimetableDao {
  final Box<Course> box;

  const CourseStorage(this.box);

  void add(Course item) {
    box.put(item.courseName.hashCode, item);
  }

  /// 根据搜索文字删除
  void delete(String record) {
    box.delete(record.hashCode);
  }

  void deleteAll() {
    box.deleteAll(box.keys.map((e) => e.hashCode));
  }

  @override
  Future<List<Course>> getTimetable(SchoolYear schoolYear, Semester semester) async {
    var result = box.values.toList();
    return result;
  }
}
