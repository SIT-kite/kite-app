import 'package:kite/module/shared/entity/school.dart';
import 'package:kite/module/symbol.dart';
import 'package:kite/mock/index.dart';

void main() async {
  await init();
  await login();
  test('score test', () async {
    final table = await ExamResultInit.scoreService.getScoreList(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });

  test('edu detail test', () async {
    final table = await ExamResultInit.scoreService.getScoreDetail(
      "",
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
