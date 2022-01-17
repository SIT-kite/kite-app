import 'package:flutter_test/flutter_test.dart';
import 'package:kite/entity/edu/year_semester.dart';
import 'package:kite/services/edu/edu_session.dart';
import 'package:kite/services/edu/score.dart';
import 'package:kite/services/sso.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('edu test', () async {
    SsoSession session = SsoSession();
    EduSession eduSession = EduSession(session);
    await session.login('', '');
    var table = await ScoreService(eduSession).getScoreList(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    logger.i(table);
  });
}
