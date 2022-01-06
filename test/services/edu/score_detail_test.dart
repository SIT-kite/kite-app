import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/edu/edu.dart';
import 'package:kite/services/sso/sso.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('edu test', () async {
    Session session = Session();
    await session.login('', '');
    await session.get('http://jwxt.sit.edu.cn/sso/jziotlogin');
    var table = await ScoreDetailService(session).getScoreDetail(
      "",
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    logger.i(table);
  });
}
