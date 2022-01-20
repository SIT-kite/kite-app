import 'package:kite/dao/edu.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/service/edu.dart';
import 'package:kite/service/sso.dart';

import '../mock.dart';

void main() async {
  await init();
  await login();
  final session = SsoSession();
  final eduSession = EduSession(session);
  TimetableDao timetableDao = TimetableService(eduSession);
  test('timetable test', () async {
    var table = await timetableDao.getTimetable(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
