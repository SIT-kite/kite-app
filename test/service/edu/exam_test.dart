import 'package:kite/entity/edu/index.dart';
import 'package:kite/service/edu/index.dart';

import '../mock_util.dart';

void main() async {
  await init();
  await login();
  final eduSession = SessionPool.eduSession;
  test('exam test', () async {
    var table = await ExamService(eduSession).getExamList(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    Log.info(table);
  });
}
