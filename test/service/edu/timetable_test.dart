import 'package:kite/domain/edu/dao/index.dart';
import 'package:kite/domain/edu/entity/index.dart';
import 'package:kite/domain/edu/service/index.dart';

import '../mock_util.dart';

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
