import 'package:ikite/ikite.dart';

import '../utils.dart';
import 'course.dart';

final _defaultStartDate = DateTime.utc(0);

///
/// type: cn.edu.sit.Timetable
class SitTimetable {
  String id = "";
  String name = "";
  String description = "";
  DateTime startDate = _defaultStartDate;
  int schoolYear = 0;
  int semester = 0;

  /// The Default number of weeks is 20.
  final List<SitTimetableWeek?> weeks;

  /// The index is the CourseKey.
  final List<SitCourse> courseKey2Entity;
  final int courseKeyCounter;

  SitTimetable(this.weeks, this.courseKey2Entity, this.courseKeyCounter);

  static SitTimetable parse(List<CourseRaw> all) => parseTimetableEntity(all);

  @override
  String toString() => "[$courseKeyCounter]";
}

class SitTimetableWeek {
  /// The 7 days in a week
  final List<SitTimetableDay> days;

  SitTimetableWeek(this.days);

  factory SitTimetableWeek.$7days() {
    return SitTimetableWeek(List.generate(7, (index) => SitTimetableDay.$11slots()));
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

  factory SitTimetableDay.$11slots() {
    return SitTimetableDay(List.generate(11, (index) => <SitTimetableLesson>[]));
  }

  void add(SitTimetableLesson lesson, {required int at}) {
    assert(0 <= at && at < timeslots2Lessons.length);
    if (0 <= at && at < timeslots2Lessons.length) {
      timeslots2Lessons[at].add(lesson);
    }
  }

  /// At all lessons [atLayer]
  Iterable<SitTimetableLesson> browseLessons({required int atLayer}) sync* {
    for (final lessonsInTimeslot in timeslots2Lessons) {
      if (0 <= atLayer && atLayer < lessonsInTimeslot.length) {
        yield lessonsInTimeslot[atLayer];
      }
    }
  }

  /// At the unique lessons [atLayer].
  /// So, if the [SitTimetableLesson.duration] is more than 1, it will only yield the first lesson.
  Iterable<SitTimetableLesson> browseUniqueLessons({required int atLayer}) sync* {
    for (int timeslot = 0; timeslot < timeslots2Lessons.length; timeslot++) {
      final lessons = timeslots2Lessons[timeslot];
      if (0 <= atLayer && atLayer < lessons.length) {
        final lesson = lessons[atLayer];
        yield lesson;
        timeslot = lesson.endIndex;
      }
    }
  }

  bool hasAnyLesson({required int atLayer}) {
    for (final lessonsInTimeslot in timeslots2Lessons) {
      if (lessonsInTimeslot.isNotEmpty) {
        return true;
      }
    }
    return false;
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

  /// How many timeslots this lesson takes.
  /// It's at least 1 timeslot.
  int get duration => endIndex - startIndex + 1;

  SitTimetableLesson(this.startIndex, this.endIndex, this.courseKey);

  @override
  String toString() => "[$courseKey] $startIndex-$endIndex";
}

class SitCourse {
  final int courseKey;
  final String courseName;
  final String courseCode;
  final String classCode;
  final String campus;
  final String place;

  /// e.g.: `1-5,14` means `from 1st week to 5th week` + `14th week`.
  /// e.g.: `o2-9,12,14` means `only odd weeks from 2nd week to 9th week` + `12th week` + `14th week`
  /// If the index is `o`(odd) or `e`(even), then it must be a range.
  final List<String> weekIndices;

  /// e.g.: `1-3` means `1st slot to 3rd slot`.
  final String timeslots;
  final double courseCredit;
  final int creditHour;
  final List<String> teachers;

  const SitCourse(
    this.courseKey,
    this.courseName,
    this.courseCode,
    this.classCode,
    this.campus,
    this.place,
    this.weekIndices,
    this.timeslots,
    this.courseCredit,
    this.creditHour,
    this.teachers,
  );

  @override
  String toString() => "[$courseKey] $courseName";

  /// The result, week number, starts with 1.
  /// week 1, week2, week 3 ...
  static Iterable<int> weekIndices2EachWeekNumbers(List<String> weekIndices) sync* {
    // Then the weeks can be ["1-5周","14周","8-10周(单)"]
    for (final week in weekIndices) {
      // don't worry about empty length.
      final step = WeekStep.by(week[0]);
      // realWeek is removed the WeekStep indicator at the head.
      final realWeek = week.substring(1);
      if (step == WeekStep.single) {
        yield int.parse(realWeek);
      } else {
        final range = realWeek.split("-");
        final start = int.parse(range[0]);
        final end = int.parse(range[1]); // inclusive
        for (int i = start; i <= end; i++) {
          if (step == WeekStep.odd && i.isOdd) {
            // odd week only
            yield i;
          } else if (step == WeekStep.even && i.isEven) {
            //even week only
            yield i;
          } else {
            // all week included
            yield i;
          }
        }
      }
    }
  }

  /// Then the [weekText] could be `1-5周,14周,8-10周(单)`
  /// The return value should be `a1-5,s14,o8-10`
  static List<String> weekText2Indices(String weekText) {
    final weeks = weekText.split(',');
    // Then the weeks should be ["1-5周","14周","8-10周(单)"]
    final res = <String>[];
    for (final week in weeks) {
      final isRange = week.contains("-");
      if (week.endsWith("(单)") && isRange) {
        final range = week.removeSuffix("周(单)");
        res.add('${WeekStep.odd.indicator}$range');
      } else if (week.endsWith("(双)") && isRange) {
        final range = week.removeSuffix("周(双)");
        res.add('${WeekStep.even.indicator}$range');
      } else {
        final number = week.removeSuffix("周");
        if (number.isNotEmpty) {
          if (number.contains("-")) {
            res.add("${WeekStep.all.indicator}$number");
          } else {
            res.add("${WeekStep.single.indicator}$number");
          }
        }
      }
    }
    return res;
  }
}

class SitTimetableDataAdapter extends DataAdapter<SitTimetable> {
  @override
  String get typeName => "kite.SitTimetable";

  @override
  SitTimetable fromJson(RestoreContext ctx, Map<String, dynamic> json) {
    return SitTimetable(
      ctx.restoreNullableListByExactType<SitTimetableWeek>(json["weeks"]),
      ctx.restoreListByExactType<SitCourse>(json["courseKey2Entity"]),
      json["courseKeyCounter"] as int,
    )
      ..id = json["id"] as String
      ..name = json["name"] as String
      ..description = json["description"] as String
      ..startDate = ctx.restoreByExactType<DateTime>(json["startDate"]) as DateTime
      ..schoolYear = json["schoolYear"] as int
      ..semester = json["semester"] as int;
  }

  @override
  Map<String, dynamic> toJson(ParseContext ctx, SitTimetable obj) {
    return {
      "id": obj.id,
      "name": obj.name,
      "description": obj.description,
      "startDate": ctx.parseToJson(obj.startDate),
      "schoolYear": obj.schoolYear,
      "semester": obj.semester,
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

class SitCourseDataAdapter extends DataAdapter<SitCourse> {
  @override
  String get typeName => "kite.SitCourse";

  @override
  SitCourse fromJson(RestoreContext ctx, Map<String, dynamic> json) {
    return SitCourse(
      json["courseKey"] as int,
      json["courseName"] as String,
      json["courseCode"] as String,
      json["classCode"] as String,
      json["campus"] as String,
      json["place"] as String,
      (json["weekIndices"] as List).cast<String>(),
      json["timeslots"] as String,
      json["courseCredit"] as double,
      json["creditHour"] as int,
      (json["teachers"] as List).cast<String>(),
    );
  }

  @override
  Map<String, dynamic> toJson(ParseContext ctx, SitCourse obj) {
    return {
      "courseKey": obj.courseKey,
      "courseName": obj.courseName,
      "courseCode": obj.courseCode,
      "classCode": obj.classCode,
      "campus": obj.campus,
      "place": obj.place,
      "weekIndices": obj.weekIndices,
      "timeslots": obj.timeslots,
      "courseCredit": obj.courseCredit,
      "creditHour": obj.creditHour,
      "teachers": obj.teachers,
    };
  }
}
