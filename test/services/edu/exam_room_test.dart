import 'package:flutter_test/flutter_test.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/services/edu.dart';
import 'package:kite/services/sso.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('timetable test', () async {
    SsoSession session = SsoSession();
    await session.login('', '');
    var eduSession = EduSession(session);
    var table = await ExamRoomService(eduSession).getExamRoomList(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    logger.i(table);
  });
}
