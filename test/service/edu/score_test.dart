import 'package:kite/feature/edu/entity/index.dart';
import 'package:kite/feature/edu/init.dart';

import '../mock_util.dart';

void main() async {
  await init();
  await login();
  test('score test', () async {
    final table = await EduInitializer.score.getScoreList(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });

  test('edu detail test', () async {
    final table = await EduInitializer.score.getScoreDetail(
      "",
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
