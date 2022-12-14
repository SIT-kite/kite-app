import '../utils.dart';
import 'course.dart';

class TimetableEntity {
  final List<TimetableWeek?> weeks;
  final Map<String, CourseEntity> courseCode2Entity;

  TimetableEntity(this.weeks, this.courseCode2Entity);

  static TimetableEntity parse(List<Course> all) => parseTimetableEntity(all);
}

class TimetableWeek {
  final List<TimetableCourse?> courses;

  TimetableWeek(this.courses);
}

class TimetableCourse {
  final int duration;
  final String courseCode;

  TimetableCourse(this.duration, this.courseCode);
}

class CourseEntity {
  final String courseCode;
  final String classCode;
  final String campus;
  final String place;
  final double courseCredit;
  final int creditHour;
  final List<String> teachers;

  CourseEntity(
    this.courseCode,
    this.classCode,
    this.campus,
    this.place,
    this.courseCredit,
    this.creditHour,
    this.teachers,
  );
}
