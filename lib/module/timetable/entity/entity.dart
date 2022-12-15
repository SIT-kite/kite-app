import '../utils.dart';
import 'course.dart';

///
/// type: cn.edu.sit.Timetable
class SitTimetableEntity {
  /// The Default number of weeks is 20.
  final List<SitTimetableWeek?> weeks;

  /// The index is the CourseKey.
  final List<SitCourseEntity> courseKey2Entity;
  final int courseKeyCounter;

  SitTimetableEntity(this.weeks, this.courseKey2Entity, this.courseKeyCounter);

  static SitTimetableEntity parse(List<CourseRaw> all) => parseTimetableEntity(all);
  @override
  String toString() => "[$courseKeyCounter]";
}

class SitTimetableWeek {
  /// The 7 days in a week
  final List<SitTimetableDay> days;

  SitTimetableWeek(this.days);

  factory SitTimetableWeek.$7() {
    return SitTimetableWeek(List.generate(7, (index) => SitTimetableDay.$11()));
  }

  @override
  String toString() => "$days";
}

/// Lessons in the same Timeslot.
typedef LessonsInSlot = List<SitTimetableLesson>;

/// A Timeslot contain one or more lesson.
typedef SitTimeslots = List<LessonsInSlot>;

class SitTimetableDay {
  /// The Default number of lesson in one day is 11. But the length of [lessons] can be more.
  /// When two lessons are overlapped, it can be 12+.
  SitTimeslots timeslots2Lessons;

  SitTimetableDay(this.timeslots2Lessons);

  factory SitTimetableDay.$11() {
    return SitTimetableDay(List.generate(11, (index) => <SitTimetableLesson>[]));
  }

  void add(SitTimetableLesson lesson, {required int at}) {
    assert(0 <= at && at < timeslots2Lessons.length);
    if (0 <= at && at < timeslots2Lessons.length) {
      timeslots2Lessons[at].add(lesson);
    }
  }

  @override
  String toString() => "$timeslots2Lessons";
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

  int get duration => endIndex - startIndex + 1;

  SitTimetableLesson(this.startIndex, this.endIndex, this.courseKey);

  @override
  String toString() => "[$courseKey] $startIndex-$endIndex";
}

class SitCourseEntity {
  final int courseKey;
  final String courseName;
  final String courseCode;
  final String classCode;
  final String campus;
  final String place;
  final double courseCredit;
  final int creditHour;
  final List<String> teachers;

  SitCourseEntity(this.courseKey, this.courseName, this.courseCode, this.classCode, this.campus, this.place,
      this.courseCredit, this.creditHour, this.teachers);

  @override
  String toString() => "[$courseKey] $courseName";
}
