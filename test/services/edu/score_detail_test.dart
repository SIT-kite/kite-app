import 'package:flutter_test/flutter_test.dart';
import 'package:kite/entity/edu/year_semester.dart';
import 'package:kite/services/edu/edu_session.dart';
import 'package:kite/services/edu/score_detail.dart';
import 'package:kite/services/sso/sso.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('edu test', () async {
    SsoSession session = SsoSession();
    EduSession eduSession = EduSession(session);
    await session.login('', '');
    var table = await ScoreDetailService(eduSession).getScoreDetail(
      "",
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    logger.i(table);
  });
}
