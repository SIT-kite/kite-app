import '../utils.dart';
import 'course.dart';

///
/// type: cn.edu.sit.Timetable
class SitTimetableEntity {
  /// The Default number of weeks is 20.
  final List<SitTimetableWeek?> weeks;

  /// The index is the CourseKey.
  final List<SitCourseEntity> courseKey2Entity;
  int courseKeyCounter = 0;

  SitTimetableEntity(this.weeks, this.courseKey2Entity);

  static SitTimetableEntity parse(List<Course> all) => parseTimetableEntity(all);
}

/// Lessons in the same Timeslot.
typedef LessonsInSlot = List<SitTimetableLesson>;

/// A Timeslot contain one or more lesson.
typedef SitTimeslots = List<LessonsInSlot>;

class SitTimetableWeek {
  /// The Default number of lesson in one day is 11. But the length of [lessons] can be more.
  /// When two lessons are overlapped, it can be 12+.
  final SitTimeslots timeslots2Lessons;

  SitTimetableWeek(this.timeslots2Lessons);
}

class SitTimetableLesson {
  /// The start index of this lesson in a [SitTimetableWeek]
  final int startIndex;

  /// The end index of this lesson in a [SitTimetableWeek]
  final int endIndex;

  /// A lesson may last two or more time slots.
  /// If current [SitTimetableLesson] is a part of the whole lesson, they all have the same [courseKey].
  /// If there's no lesson, the [courseKey] is null.
  final int courseKey;

  SitTimetableLesson(this.startIndex, this.endIndex, this.courseKey);
}

class SitCourseEntity {
  final int courseKey;
  final String courseCode;
  final String classCode;
  final String campus;
  final String place;
  final double courseCredit;
  final int creditHour;
  final List<String> teachers;

  SitCourseEntity(this.courseKey, this.courseCode, this.classCode, this.campus, this.place, this.courseCredit,
      this.creditHour, this.teachers);
}
