import 'package:kite/module/shared/entity/school.dart';
import 'package:kite/module/symbol.dart';
import '../../init.dart';

void main() async {
  await init();
  await login();
  test('score test', () async {
    final table = await ExamResultInit.resultService.getResultList(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });

  test('edu detail test', () async {
    final table = await ExamResultInit.resultService.getResultDetail(
      "",
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
