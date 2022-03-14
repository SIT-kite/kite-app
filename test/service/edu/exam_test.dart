import 'package:kite/feature/edu/common/entity/index.dart';
import 'package:kite/feature/edu/exam/init.dart';

import '../mock_util.dart';

void main() async {
  await init();
  await login();
  test('exam test', () async {
    var table = await ExamInitializer.examService.getExamList(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    // Log.info(table);
    print(table);
  });
}
