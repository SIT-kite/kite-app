import 'package:kite/module/shared/entity/school.dart';
import 'package:kite/module/symbol.dart';
import 'package:kite/mock/index.dart';

void main() async {
  await init();
  await login();
  final timetableDao = TimetableInit.timetableService;
  test('timetable test', () async {
    final table = await timetableDao.getTimetable(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
