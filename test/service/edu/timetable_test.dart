import 'package:kite/domain/edu/dao/index.dart';
import 'package:kite/domain/edu/entity/index.dart';
import 'package:kite/domain/edu/init.dart';

import '../mock_util.dart';

void main() async {
  await init();
  await login();
  TimetableDao timetableDao = EduInitializer.timetable;
  test('timetable test', () async {
    final table = await timetableDao.getTimetable(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
