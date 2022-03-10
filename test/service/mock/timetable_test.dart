import 'package:kite/feature/edu/dao/timetable.dart';
import 'package:kite/feature/edu/entity/index.dart';
import 'package:kite/feature/edu/mock/timetable.dart';

import '../mock_util.dart';

void main() {
  final TimetableDao timetableDao = TimetableMock();
  test('timetableMock test', () async {
    final timetable = await timetableDao.getTimetable(SchoolYear.all, Semester.all);
    Log.info(timetable);
  });
}
