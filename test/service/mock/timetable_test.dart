import 'package:kite/domain/edu/dao/timetable.dart';
import 'package:kite/domain/edu/entity/index.dart';
import 'package:kite/domain/edu/mock/timetable.dart';

import '../mock_util.dart';

void main() {
  final TimetableDao timetableDao = TimetableMock();
  test('timetableMock test', () async {
    final timetable = await timetableDao.getTimetable(SchoolYear.all, Semester.all);
    Log.info(timetable);
  });
}
