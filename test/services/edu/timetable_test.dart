import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/edu/edu.dart';
import 'package:kite/services/edu/src/edu_session.dart';
import 'package:kite/services/sso/src/session.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('timetable test', () async {
    Session session = Session();
    await session.login('', '');
    var eduSession = EduSession(session);
    var table = await TimetableService(eduSession).getTimetable(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    logger.i(table);
  });
}
