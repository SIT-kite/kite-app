import 'package:flutter_test/flutter_test.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/service/edu.dart';
import 'package:kite/service/sso.dart';
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

  test('edu detail test', () async {
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
