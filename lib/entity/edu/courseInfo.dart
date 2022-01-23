import 'package:hive/hive.dart';
import 'package:kite/global/hive_type_id_pool.dart';

part 'courseInfo.g.dart';

@HiveType(typeId: HiveTypeIdPool.courseItem)
class CourseItem extends HiveObject {
  @HiveField(0)
  String courseName = '';

  @HiveField(1)
  int day = 0;

  @HiveField(2)
  int timeIndex = 0;

  @HiveField(3)
  int week = 0;

  @HiveField(4)
  String place = '';

  @HiveField(5)
  List<String> teacher = [];

  @HiveField(6)
  String campus = '';

  @HiveField(7)
  double credit = 0.0;

  @HiveField(8)
  int hour = 0;

  @HiveField(9)
  String dynClassId = '';

  @HiveField(10)
  String courseId = '';

  @override
  String toString() {
    return 'CourseItem{courseName: $courseName, day: $day, timeIndex: $timeIndex, week: $week, place: $place, teacher: $teacher, campus: $campus, credit: $credit, hour: $hour, dynClassId: $dynClassId, courseId: $courseId}';
  }
}

