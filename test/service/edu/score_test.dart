import 'package:kite/feature/edu/common/entity/index.dart';
import 'package:kite/feature/edu/score/init.dart';

import '../mock_util.dart';

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
