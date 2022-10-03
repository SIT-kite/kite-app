import 'package:kite/module/edu/common/entity/index.dart';
import 'package:kite/module/edu/exam/init.dart';
import 'package:kite/mock/index.dart';

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
