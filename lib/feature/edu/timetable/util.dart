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

import 'package:ical/serializer.dart';
import 'package:intl/intl.dart';
import 'package:kite/util/file.dart';

import 'entity.dart';
import 'page/util.dart';

void _addEventForCourse(ICalendar cal, Course course, DateTime startDate) {
  final timetable = getBuildingTimetable(course.campus, course.place);
  final indexStart = getIndexStart(course.timeIndex);
  final indexEnd = getIndexEnd(indexStart, course.timeIndex);
  final timeStart = timetable[indexStart - 1].start;
  final timeEnd = timetable[indexEnd - 1].end;

  final description = '第 ${timeStart == timeEnd ? timeStart : '$timeStart-$timeEnd'} 节\n'
      '${course.place}\n'
      '${course.teacher.join(', ')}';

  // 一学期最多有 20 周
  for (int currentWeek = 1; currentWeek < 20; ++currentWeek) {
    // 本周没课, 跳过
    if ((1 << currentWeek) & course.weekIndex == 0) continue;

    final date = getDateFromWeekDay(startDate, currentWeek, course.dayIndex);
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

///导出的方法
String convertTableToIcs(TimetableMeta meta, List<Course> courses) {
  final ICalendar iCal = ICalendar(
    company: 'Kite Team, Yiban WorkStation of Shanghai Institute of Technology',
    product: 'kite',
    lang: 'ZH',
  );
  // 需要把
  final startDate = DateTime(meta.startDate.year, meta.startDate.month, meta.startDate.day);
  for (final course in courses) {
    _addEventForCourse(iCal, course, startDate);
  }
  return iCal.serialize();
}

Future<void> exportTimetableToCalendar(TimetableMeta meta, List<Course> courses) async {
  await FileUtils.writeToTempFileAndOpen(
    content: convertTableToIcs(meta, courses),
    filename: 'kite_table_${DateFormat('yyyyMMdd_hhmmss').format(DateTime.now())}.ics',
    type: 'text/calendar',
  );
}
