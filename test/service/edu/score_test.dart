import 'package:kite/entity/edu.dart';
import 'package:kite/service/edu.dart';

import '../mock.dart';

void main() async {
  await init();
  await login();
  final eduSession = SessionPool.eduSession;
  test('score test', () async {
    final table = await ScoreService(eduSession).getScoreList(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });

  test('edu detail test', () async {
    final table = await ScoreService(eduSession).getScoreDetail(
      "",
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
