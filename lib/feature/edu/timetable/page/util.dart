/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:flutter/material.dart';
import 'package:ical/serializer.dart';

import '../entity/timetable.dart';
import '../init.dart';

//静态
class ABC {}

// -- 基本常量
final dateSemesterStart = TimetableInitializer.timetableStorage.startDate ?? DateTime(2022, 2, 14);

final List<String> weekWord = ['一', '二', '三', '四', '五', '六', '日'];

final List<Color> colorList = [
  const Color.fromARGB(178, 251, 83, 82),
  const Color.fromARGB(153, 115, 123, 250),
  const Color.fromARGB(178, 116, 185, 255),
  const Color.fromARGB(178, 118, 126, 253),
  const Color.fromARGB(178, 245, 175, 77),
  const Color.fromARGB(178, 187, 137, 106),
  const Color.fromARGB(178, 232, 67, 147),
  const Color.fromARGB(178, 188, 140, 240),
  const Color.fromARGB(178, 116, 185, 255)
];

Color getBeautifulColor(int hashCode) {
  return colorList[hashCode % colorList.length];
}

class Time {
  /// 小时
  final int hour;

  /// 分
  final int minute;

  const Time(this.hour, this.minute);

  @override
  String toString() => '$hour:' + '$minute'.padLeft(2, '0');
}

class CourseEnd {
  /// 上课时间
  final Time start;

  /// 下课时间
  final Time end;

  const CourseEnd(this.start, this.end);
}

const fengxianCourseEnd = [
  // 上午
  CourseEnd(Time(8, 20), Time(9, 05)),
  CourseEnd(Time(9, 10), Time(9, 55)),
  CourseEnd(Time(10, 15), Time(11, 00)),
  CourseEnd(Time(11, 05), Time(11, 50)),
  // 下午
  CourseEnd(Time(13, 00), Time(13, 45)),
  CourseEnd(Time(13, 50), Time(14, 35)),
  CourseEnd(Time(14, 55), Time(15, 40)),
  CourseEnd(Time(15, 45), Time(16, 30)),
  // 晚上
  CourseEnd(Time(18, 00), Time(18, 45)),
  CourseEnd(Time(18, 50), Time(19, 35)),
  CourseEnd(Time(19, 40), Time(20, 25)),
];

const building1CourseEnd = [
  // 上午
  CourseEnd(Time(8, 20), Time(9, 05)),
  CourseEnd(Time(9, 10), Time(9, 55)),
  CourseEnd(Time(10, 25), Time(11, 10)),
  CourseEnd(Time(11, 15), Time(12, 00)),
  // 下午
  CourseEnd(Time(13, 00), Time(13, 45)),
  CourseEnd(Time(13, 50), Time(14, 35)),
  CourseEnd(Time(14, 55), Time(15, 40)),
  CourseEnd(Time(15, 45), Time(16, 30)),
  // 晚上
  CourseEnd(Time(18, 00), Time(18, 45)),
  CourseEnd(Time(18, 50), Time(19, 35)),
  CourseEnd(Time(19, 40), Time(20, 25)),
];

const building2CourseEnd = [
  // 上午 （3-4不下课）
  CourseEnd(Time(8, 20), Time(9, 05)),
  CourseEnd(Time(9, 10), Time(9, 55)),
  CourseEnd(Time(10, 15), Time(11, 00)),
  CourseEnd(Time(11, 00), Time(11, 45)),
  // 下午
  CourseEnd(Time(13, 00), Time(13, 45)),
  CourseEnd(Time(13, 50), Time(14, 35)),
  CourseEnd(Time(14, 55), Time(15, 40)),
  CourseEnd(Time(15, 45), Time(16, 30)),
  // 晚上
  CourseEnd(Time(18, 00), Time(18, 45)),
  CourseEnd(Time(18, 50), Time(19, 35)),
  CourseEnd(Time(19, 40), Time(20, 25)),
];

const xuhuiCourseEnd = [
  // 上午
  CourseEnd(Time(8, 00), Time(8, 45)),
  CourseEnd(Time(8, 50), Time(9, 35)),
  CourseEnd(Time(9, 55), Time(10, 40)),
  CourseEnd(Time(10, 45), Time(11, 30)),
  // 下午
  CourseEnd(Time(13, 00), Time(13, 45)),
  CourseEnd(Time(13, 50), Time(14, 35)),
  CourseEnd(Time(14, 55), Time(15, 40)),
  CourseEnd(Time(15, 45), Time(16, 30)),
  // 晚上
  CourseEnd(Time(18, 00), Time(18, 45)),
  CourseEnd(Time(18, 50), Time(19, 35)),
  CourseEnd(Time(19, 40), Time(20, 25)),
];

/// 解析 timeIndex, 得到第一节小课的序号. 如给出 1~4, 返回 1
int getIndexStart(int index) {
  int i = 0;
  while (index & 1 == 0) {
    i++;
    index >>= 1;
  }
  return i;
}

/// 解析 timeIndex, 得到最后一节小课的序号. 如给出 1~4, 返回 4
int getIndexEnd(int start, int index) {
  int i = start;
  index >>= start + 1;
  while (index & 1 != 0) {
    i++;
    index >>= 1;
  }
  return i;
}

List<CourseEnd> getBuildingTimetable(String campus, String place) {
  if (campus.contains('徐汇')) {
    return xuhuiCourseEnd;
  }
  if (place.startsWith('一教')) {
    return building1CourseEnd;
  } else if (place.startsWith('二教')) {
    return building2CourseEnd;
  }
  return fengxianCourseEnd;
}

/// 将 "第几周、周几" 转换为日期. 如, 开学日期为 2021-9-1, 那么将第一周周一转换为 2021-9-1
DateTime getDateFromWeekDay(DateTime semesterBegin, int week, int day) {
  return semesterBegin.add(Duration(days: (week - 1) * 7 + day - 1));
}

/// 将 timeIndex 转换为对应的字符串
///
/// ss: 开始时间
/// ee: 结束时间
/// SS: 开始的节次
/// EE: 结束的节次
String formatTimeIndex(List<CourseEnd> timetable, int timeIndex, String format) {
  final indexStart = getIndexStart(timeIndex);
  final indexEnd = getIndexEnd(indexStart, timeIndex);
  final timeStart = timetable[indexStart - 1].start;
  final timeEnd = timetable[indexEnd - 1].end;

  return format
      .replaceAll('ss', timeStart.toString())
      .replaceAll('ee', timeEnd.toString())
      .replaceAll('SS', indexStart.toString())
      .replaceAll('EE', indexEnd.toString());
}

/// 删去 place 括号里的描述信息. 如, 二教F301（机电18中外合作专用）
String formatPlace(String place) {
  int indexOfBucket = place.indexOf('（');
  if (indexOfBucket != -1) {
    return place.substring(0, indexOfBucket);
  }
  indexOfBucket = place.indexOf('(');
  return indexOfBucket != -1 ? place.substring(0, indexOfBucket) : place;
}

void addEventForCourse(ICalendar cal, Course course) {
  final timetable = getBuildingTimetable(course.campus, course.place);
  final indexStart = getIndexStart(course.timeIndex);
  final indexEnd = getIndexEnd(indexStart, course.timeIndex);
  final timeStart = timetable[indexStart - 1].start;
  final timeEnd = timetable[indexEnd - 1].end;

  final description = '第 ${timeStart == timeEnd ? timeStart : "$timeStart-$timeEnd"} 节\n'
      '${course.place}\n'
      '${course.teacher.join(', ')}';

  // 一学期最多有 20 周
  for (int currentWeek = 1; currentWeek < 20; ++currentWeek) {
    // 本周没课, 跳过
    if ((1 << currentWeek) & course.weekIndex == 0) continue;

    final date = getDateFromWeekDay(dateSemesterStart, currentWeek, course.dayIndex);
    final IEvent event = IEvent(
      // uid: 'SIT-KITE-${course.courseId}-${const Uuid().v1()}',
      summary: course.courseName,
      description: '第 ${course.teacher.join(', ')} | ',
      location: description,
      start: date.add(Duration(hours: timeStart.hour, minutes: timeStart.minute)),
      end: date.add(Duration(hours: timeEnd.hour, minutes: timeEnd.minute)),
    );
    cal.addElement(event);
  }
}
