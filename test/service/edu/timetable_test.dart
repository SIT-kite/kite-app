import 'package:kite/feature/edu/common/entity/index.dart';
import 'package:kite/feature/edu/timetable/init.dart';
import 'package:kite/mock/index.dart';

void main() async {
  await init();
  await login();
  final timetableDao = TimetableInitializer.timetableService;
  test('timetable test', () async {
    final table = await timetableDao.getTimetable(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
