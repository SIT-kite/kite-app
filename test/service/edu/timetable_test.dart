import 'package:kite/dao/edu/index.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/service/edu/index.dart';

import '../mock.dart';

void main() async {
  await init();
  await login();
  final eduSession = SessionPool.eduSession;
  TimetableDao timetableDao = TimetableService(eduSession);
  test('timetable test', () async {
    final table = await timetableDao.getTimetable(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
