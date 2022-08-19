import 'package:ical/serializer.dart';
import 'package:kite/util/file.dart';

import 'entity.dart';
import 'page/util.dart';

void _addEventForCourse(ICalendar cal, Course course, DateTime startDate) {
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
  for (final course in courses) {
    _addEventForCourse(iCal, course, meta.startDate);
  }
  return iCal.serialize();
}

Future<void> exportTimetableToCalendar(TimetableMeta meta, List<Course> courses) async {
  await FileUtils.writeToTempFileAndOpen(
    content: convertTableToIcs(meta, courses),
    filename: 'kite_table.ics',
    type: 'text/calendar',
  );
}
