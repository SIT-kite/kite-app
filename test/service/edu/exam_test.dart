import 'package:kite/feature/edu/entity/index.dart';
import 'package:kite/feature/edu/init.dart';

import '../mock_util.dart';

void main() async {
  await init();
  await login();
  test('exam test', () async {
    var table = await EduInitializer.exam.getExamList(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    // Log.info(table);
    print(table);
  });
}
