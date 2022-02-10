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

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:kite/entity/edu/index.dart';

final dateSemesterStart = DateTime(2022, 2, 14);

class Time {
  /// 小时
  final int hour;

  /// 分
  final int minute;

  const Time(this.hour, this.minute);
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
  index >>= start;
  while (index & 1 == 1) {
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

List<Event> createEventFromCourse(Course course) {
  final timetable = getBuildingTimetable(course.campus, course.place);
  final indexStart = getIndexStart(course.timeIndex);
  final indexEnd = getIndexEnd(indexStart, course.timeIndex);
  final timeStart = timetable[indexStart - 1].start;
  final timeEnd = timetable[indexEnd - 1].end;

  final description = '第 ${timeStart == timeEnd ? timeStart : "$timeStart-$timeEnd"} 节\n'
      '${course.place}\n'
      '${course.teacher.join(', ')}';

  final List<Event> result = [];
  // 一学期最多有 20 周
  for (int currentWeek = 1; currentWeek < 20; ++currentWeek) {
    // 本周没课, 跳过
    if ((1 << currentWeek) & course.weekIndex == 0) continue;

    final date = getDateFromWeekDay(dateSemesterStart, currentWeek, course.dayIndex);
    final Event event = Event(
      title: course.courseName,
      description: '第 ${course.teacher.join(', ')} | ',
      location: description,
      startDate: date.add(Duration(hours: timeStart.hour, minutes: timeStart.minute)),
      endDate: date.add(Duration(hours: timeEnd.hour, minutes: timeEnd.minute)),
      timeZone: 'Asia/Shanghai',
    );
    result.add(event);
  }
  return result;
}
