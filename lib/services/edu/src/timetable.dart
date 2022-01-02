import 'dart:convert';
import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:kite/services/sso/src/session.dart';

part 'timetable.g.dart';

RegExp weekRegex = RegExp(r"(\d{1,2})(:?-(\d{1,2}))?");

class TimetableService {
  Session _session;

  TimetableService(this._session);
}

@JsonSerializable()
class Course {
  @JsonKey(name: 'kcmc')
  // 课程名称
  String? courseName;
  @JsonKey(name: 'xqjmc', fromJson: dayToInt)
  // 星期
  int? day;
  @JsonKey(name: 'jcs', fromJson: indexTimeToInt)
  // 节次
  int? timeIndex;
  @JsonKey(name: 'zcd', fromJson: weeksToInt)
  // 周次
  int? week;
  @JsonKey(name: 'cdmc')
  // 教室
  String? place;
  @JsonKey(name: 'xm', fromJson: stringToVec, defaultValue: ['空'])
  // 教师
  List<String>? teacher;
  @JsonKey(name: 'xqmc')
  // 校区
  String? campus;
  @JsonKey(name: 'xf', fromJson: stringToDouble)
  // 学分
  double credit = 0.0;
  @JsonKey(name: 'zxs', fromJson: stringToInt)
  // 学时
  int hour = 0;
  @JsonKey(name: 'jxbmc', fromJson: trimString)
  // 教学班
  String? dynClassId;
  @JsonKey(name: 'kch')
  // 课程代码
  String? courseId;

  Course();

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}

int transWeek(String weekDay) {
  Map<String, int> weeks = {
    '星期一': 1,
    '星期二': 2,
    '星期三': 3,
    '星期四': 4,
    '星期五': 5,
    '星期六': 6,
    '星期日': 7
  };
  var result = weeks[weekDay];
  if (result == null) {
    return 0;
  } else {
    return result;
  }
}

List<int> expandWeeks(String week) {
  int checkWeekIndex(String? x) {
    if (x == null) {
      return 0;
    } else {
      var result = int.tryParse(x);
      if (result == null) {
        return 0;
      } else {
        return result;
      }
    }
  }

  List<int> weeks = [];
  week.split(',').forEach((week) {
    if (week.contains('-')) {
      var step = 1;
      if (week.endsWith("(单)") || week.endsWith("(双)")) {
        step = 2;
      }
      var range = weekRegex.firstMatch(week)!;
      var weekList = range[0]!.split('-');
      var min = checkWeekIndex(weekList[0]);
      var max = checkWeekIndex(weekList[1]);
      while (min < max + 1) {
        weeks.add(min);
        min += step;
      }
    } else {
      weeks.add(checkWeekIndex(week.replaceAll("周", "")));
    }
  });
  return weeks;
}

List<int> expandTime(String time) {
  int checkTimeIndex(String? x) {
    if (x == null) {
      return 0;
    } else {
      var result = int.tryParse(x);
      if (result == null) {
        return 0;
      } else {
        return result;
      }
    }
  }

  List<int> indices = [];
  if (time.contains('-')) {
    var result = time.split("-");
    var min = checkTimeIndex(result.first);
    var max = checkTimeIndex(result.last) + 1;
    for (var i = min; i < max; i++) {
      indices.add(i);
    }
  } else {
    indices.add(checkTimeIndex(time));
  }
  return indices;
}

List<String> splitToList(String s) {
  if (s.isEmpty) {
    return [];
  } else {
    List<String> result = [];
    s.split(',').forEach((element) {
      result.add(element.toString());
    });
    return result;
  }
}

int listToInt(List<int> s) {
  var binaryNumber = 0;
  for (var number in s) {
    binaryNumber |= 1 << number;
  }
  return binaryNumber;
}

int weeksToInt(String weeks) {
  var result = expandWeeks(weeks);

  return listToInt(result);
}

int dayToInt(String days) {
  var result = transWeek(days);
  return result;
}

int indexTimeToInt(String indexTime) {
  var result = expandTime(indexTime);
  return listToInt(result);
}

List<String> stringToVec(String s) {
  var result = splitToList(s);
  return result;
}

double stringToDouble(String s) {
  var result = double.tryParse(s);
  if (result == null) {
    return -1.0;
  } else {
    return result;
  }
}

int stringToInt(String s) {
  var result = int.tryParse(s);
  if (result == null) {
    return 0;
  } else {
    return result;
  }
}

String trimString(String s) {
  return s.trim();
}

List<Course> parseTimetablePage(String page) {
  var jsonPage = jsonDecode(page);
  List<Course> result = [];
  for (var course in jsonPage["kbList"]) {
    Course newCourse = Course();
    newCourse = Course.fromJson(course);
    result.add(newCourse);
  }
  return result;
}
