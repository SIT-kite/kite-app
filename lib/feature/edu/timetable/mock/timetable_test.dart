import 'package:kite/feature/edu/common/entity/index.dart';
import 'package:kite/feature/edu/timetable/dao/timetable.dart';
import 'package:kite/feature/edu/timetable/mock/timetable.dart';
import 'package:kite/mock/index.dart';

void main() {
  final TimetableDao timetableDao = TimetableMock();
  test('timetableMock test', () async {
    final timetable = await timetableDao.getTimetable(SchoolYear.all, Semester.all);
    Log.info(timetable);
  });
}
