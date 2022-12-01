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
import 'using.dart';

import 'entity/course.dart';
import 'entity/meta.dart';

List<String> makeWeekdaysShortText() => [
      i18n.weekdayShort1,
      i18n.weekdayShort2,
      i18n.weekdayShort3,
      i18n.weekdayShort4,
      i18n.weekdayShort5,
      i18n.weekdayShort6,
      i18n.weekdayShort7
    ];

List<String> makeWeekdaysText() =>
    [i18n.weekday1, i18n.weekday2, i18n.weekday3, i18n.weekday4, i18n.weekday5, i18n.weekday6, i18n.weekday7];

void _addEventForCourse(ICalendar cal, Course course, DateTime startDate, Duration? alarmBefore) {
  final timetable = getBuildingTimetable(course.campus, course.place);
  final indexStart = getIndexStart(course.timeIndex);
  final indexEnd = getIndexEnd(indexStart, course.timeIndex);
  final timeStart = timetable[indexStart - 1].start;
  final timeEnd = timetable[indexEnd - 1].end;

  final description =
      '第 ${indexStart == indexEnd ? indexStart : '$indexStart-$indexEnd'} 节，${course.place}，${course.teacher.join(' ')}';

  // 一学期最多有 20 周
  for (int currentWeek = 1; currentWeek < 20; ++currentWeek) {
    // 本周没课, 跳过
    if ((1 << currentWeek) & course.weekIndex == 0) continue;

    // 这里需要使用UTC时间
    // 实际测试得出，如果不使用UTC，有的手机会将其看作本地时间
    // 有的手机会将其看作UTC+0的时间从而导致实际显示时间与预期不一致
    final date = getDateFromWeekDay(startDate, currentWeek, course.dayIndex).toUtc();
    final eventStartTime = date.add(Duration(hours: timeStart.hour, minutes: timeStart.minute));
    final eventEndTime = date.add(Duration(hours: timeEnd.hour, minutes: timeEnd.minute));
    final IEvent event = IEvent(
      // uid: 'SIT-KITE-${course.courseId}-${const Uuid().v1()}',
      summary: course.courseName,
      location: course.place,
      description: description,
      start: eventStartTime,
      end: eventEndTime,
      alarm: alarmBefore == null
          ? null
          : IAlarm.display(
              trigger: eventStartTime.subtract(alarmBefore),
              description: description,
            ),
    );
    cal.addElement(event);
  }
}

///导出的方法
String convertTableToIcs(TimetableMeta meta, List<Course> courses, Duration? alarmBefore) {
  final ICalendar iCal = ICalendar(
    company: 'Kite Team, Yiban WorkStation of Shanghai Institute of Technology',
    product: 'kite',
    lang: 'ZH',
    refreshInterval: const Duration(days: 36500),
  );
  // 需要把
  final startDate = DateTime(meta.startDate.year, meta.startDate.month, meta.startDate.day);
  for (final course in courses) {
    _addEventForCourse(iCal, course, startDate, alarmBefore);
  }
  return iCal.serialize();
}

String getExportTimetableFilename() {
  return 'kite_table_${DateFormat('yyyyMMdd_hhmmss').format(DateTime.now())}.ics';
}

Future<void> exportTimetableToCalendar(TimetableMeta meta, List<Course> courses, Duration? alarmBefore) async {
  await FileUtils.writeToTempFileAndOpen(
    content: convertTableToIcs(meta, courses, alarmBefore),
    filename: getExportTimetableFilename(),
    type: 'text/calendar',
  );
}
