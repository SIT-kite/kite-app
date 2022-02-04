import 'package:kite/dao/edu/timetable.dart';
import 'package:kite/entity/edu/index.dart';
import 'package:kite/mock/edu/timetable.dart';

import '../mock_util.dart';

void main() {
  final TimetableDao timetableDao = TimetableMock();
  test('timetableMock test', () async {
    final timetable = await timetableDao.getTimetable(SchoolYear.all, Semester.all);
    Log.info(timetable);
  });
}
