import 'package:ikite/ikite.dart';

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

  SitCourseEntity(
    this.courseKey,
    this.courseName,
    this.courseCode,
    this.classCode,
    this.campus,
    this.place,
    this.courseCredit,
    this.creditHour,
    this.teachers,
  );

  @override
  String toString() => "[$courseKey] $courseName";
}

class SitTimetableEntityDataAdapter extends DataAdapter<SitTimetableEntity> {
  @override
  String get typeName => "kite.SitTimetableEntity";

  @override
  SitTimetableEntity fromJson(RestoreContext ctx, Map<String, dynamic> json) {
    return SitTimetableEntity(
      ctx.restoreNullableListByExactType<SitTimetableWeek>(json["weeks"]),
      ctx.restoreListByExactType<SitCourseEntity>(json["courseKey2Entity"]),
      json["courseKeyCounter"] as int,
    );
  }

  @override
  Map<String, dynamic> toJson(ParseContext ctx, SitTimetableEntity obj) {
    return {
      "weeks": ctx.parseToNullableList(obj.weeks),
      "courseKey2Entity": ctx.parseToList(obj.courseKey2Entity),
      "courseKeyCounter": obj.courseKeyCounter,
    };
  }
}

class SitTimetableWeekDataAdapter extends DataAdapter<SitTimetableWeek> {
  @override
  String get typeName => "kite.SitTimetableWeek";

  @override
  SitTimetableWeek fromJson(RestoreContext ctx, Map<String, dynamic> json) {
    return SitTimetableWeek(
      ctx.restoreListByExactType(json["days"]),
    );
  }

  @override
  Map<String, dynamic> toJson(ParseContext ctx, SitTimetableWeek obj) {
    return {"days": ctx.parseToList(obj.days)};
  }
}

class SitTimetableDayDataAdapter extends DataAdapter<SitTimetableDay> {
  @override
  String get typeName => "kite.SitTimetableDay";

  @override
  SitTimetableDay fromJson(RestoreContext ctx, Map<String, dynamic> json) {
    return SitTimetableDay(ctx.restore2DListByExactType<SitTimetableLesson>(json["timeslots2Lessons"]));
  }

  @override
  Map<String, dynamic> toJson(ParseContext ctx, SitTimetableDay obj) {
    return {"timeslots2Lessons": ctx.parseTo2DList(obj.timeslots2Lessons)};
  }
}

class SitTimetableLessonDataAdapter extends DataAdapter<SitTimetableLesson> {
  @override
  String get typeName => "kite.SitTimetableLesson";

  @override
  SitTimetableLesson fromJson(RestoreContext ctx, Map<String, dynamic> json) {
    return SitTimetableLesson(
      json["startIndex"] as int,
      json["endIndex"] as int,
      json["courseKey"] as int,
    );
  }

  @override
  Map<String, dynamic> toJson(ParseContext ctx, SitTimetableLesson obj) {
    return {
      "startIndex": obj.startIndex,
      "endIndex": obj.endIndex,
      "courseKey": obj.courseKey,
    };
  }
}

class SitCourseEntityDataAdapter extends DataAdapter<SitCourseEntity> {
  @override
  String get typeName => "kite.SitCourseEntity";

  @override
  SitCourseEntity fromJson(RestoreContext ctx, Map<String, dynamic> json) {
    return SitCourseEntity(
      json["courseKey"] as int,
      json["courseName"] as String,
      json["courseCode"] as String,
      json["classCode"] as String,
      json["campus"] as String,
      json["place"] as String,
      json["courseCredit"] as double,
      json["creditHour"] as int,
      json["teachers"] as List<String>,
    );
  }

  @override
  Map<String, dynamic> toJson(ParseContext ctx, SitCourseEntity obj) {
    return {
      "courseKey": obj.courseKey,
      "courseName": obj.courseName,
      "courseCode": obj.courseCode,
      "classCode": obj.classCode,
      "campus": obj.campus,
      "place": obj.place,
      "courseCredit": obj.courseCredit,
      "creditHour": obj.creditHour,
      "teachers": obj.teachers,
    };
  }
}
