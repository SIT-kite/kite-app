import 'package:kite/module/edu/common/entity/index.dart';
import 'package:kite/module/edu/score/init.dart';
import 'package:kite/mock/index.dart';

void main() async {
  await init();
  await login();
  test('score test', () async {
    final table = await ScoreInitializer.scoreService.getScoreList(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });

  test('edu detail test', () async {
    final table = await ScoreInitializer.scoreService.getScoreDetail(
      "",
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
