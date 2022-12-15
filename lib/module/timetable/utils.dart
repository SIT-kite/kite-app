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
import 'entity/entity.dart';
import 'using.dart';

import 'entity/course.dart';
import 'entity/meta.dart';

const maxWeekLength = 20;

List<String> makeWeekdaysShortText() =>
    [
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
      '第 ${indexStart == indexEnd ? indexStart : '$indexStart-$indexEnd'} 节，${course.place}，${course.teacher.join(
      ' ')}';

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
String convertTableToIcs(TimetableMetaLegacy meta, List<Course> courses, Duration? alarmBefore) {
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

Future<void> exportTimetableToCalendar(TimetableMetaLegacy meta, List<Course> courses, Duration? alarmBefore) async {
  await FileUtils.writeToTempFileAndOpen(
    content: convertTableToIcs(meta, courses, alarmBefore),
    filename: getExportTimetableFilename(),
    type: 'text/calendar',
  );
}

final Map<String, int> _weekday2Index = {'星期一': 1, '星期二': 2, '星期三': 3, '星期四': 4, '星期五': 5, '星期六': 6, '星期日': 7};

/// The result, week number, starts with 1.
/// week 1, week2, week 3 ...
Iterable<int> _weekText2WeekNumbers(String weekText) sync* {
  final weeks = weekText.split(',');
  // Then the weeks can be ["1-5周","14周","8-10周(单)"]
  for (final week in weeks) {
    if (week.endsWith("(单)")) {
      final rangeText = week.removeSuffix("周(单)");
      if (rangeText.contains("-")) {
        // if the odd is specified, it must be a range
        final range = rangeText.split("-");
        final start = int.parse(range[0]);
        final end = int.parse(range[1]); // inclusive
        for (int i = start; i <= end; i++) {
          if (i.isOdd) yield i;
        }
      }
    } else if (week.endsWith("(双)")) {
      final rangeText = week.removeSuffix("周(双)");
      if (rangeText.contains("-")) {
        // if the even is specified, it must be a range
        final range = rangeText.split("-");
        final start = int.parse(range[0]);
        final end = int.parse(range[1]); // inclusive
        for (int i = start; i <= end; i++) {
          if (i.isEven) yield i;
        }
      }
    } else {
      final rangeText = week.removeSuffix("周");
      if (rangeText.contains("-")) {
        // a range
        final range = rangeText.split("-");
        final start = int.parse(range[0]);
        final end = int.parse(range[1]); // inclusive
        for (int i = start; i <= end; i++) {
          yield i;
        }
      } else {
        // a single number
        yield int.parse(rangeText);
      }
    }
  }
}

extension _StringEx on String {
  String removeSuffix(String suffix) => endsWith(suffix) ? substring(0, length - suffix.length) : this;

  String removePrefix(String prefix) => startsWith(prefix) ? substring(prefix.length) : this;
}

SitTimetable parseTimetableEntity(List<CourseRaw> all) {
  final List<SitTimetableWeek?> weeks = List.generate(20, (index) => null);
  SitTimetableWeek getWeekAt(int index) {
    var week = weeks[index] ??= SitTimetableWeek.$7days();
    weeks[index] = week;
    return week;
  }

  final List<SitCourse> courseKey2Entity = [];
  var counter = 0;
  for (final raw in all) {
    final courseKey = counter++;
    final course = SitCourse(
      courseKey,
      raw.courseName.trim(),
      raw.courseCode.trim(),
      raw.classCode.trim(),
      raw.campus,
      raw.place,
      double.tryParse(raw.courseCredit) ?? 0.0,
      int.tryParse(raw.creditHour) ?? 0,
      raw.teachers.split(","),
    );
    courseKey2Entity.add(course);
    final dayIndex = _weekday2Index[raw.weekDayText];
    assert(dayIndex != null, "It's no corresponding dayIndex of ${raw.weekDayText}");
    if (dayIndex == null) continue;
    assert(0 <= dayIndex && dayIndex < 7, "dayIndex is out of range [0,6]");
    if (!(0 <= dayIndex && dayIndex < 7)) continue;
    for (final weekNumber in _weekText2WeekNumbers(raw.weekText)) {
      final weekIndex = weekNumber - 1;
      assert(0 <= weekIndex && weekIndex < maxWeekLength, "Week index is more out of range [0,$maxWeekLength).");
      if (0 <= weekIndex && weekIndex < maxWeekLength) {
        final week = getWeekAt(weekIndex);
        final day = week.days[dayIndex];
        if (raw.timeslotsText.contains("-")) {
          // in range of time slots
          final range = raw.timeslotsText.split("-");
          final startIndex = int.parse(range[0]) - 1;
          final endIndex = int.parse(range[1]) - 1; // inclusive
          for (int slot = startIndex; slot <= endIndex; slot++) {
            day.add(SitTimetableLesson(startIndex, endIndex, courseKey), at: slot);
          }
        } else {
          final slot = int.parse(raw.timeslotsText) - 1;
          day.add(SitTimetableLesson(slot, slot, courseKey), at: slot);
        }
      }
    }
  }
  final res = SitTimetable(weeks, courseKey2Entity, counter);
  return res;
}
