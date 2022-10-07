import 'package:kite/mock/index.dart';
import 'package:kite/module/shared/entity/school.dart';
import 'package:kite/module/symbol.dart';

void main() async {
  await init();
  await login();
  test('exam test', () async {
    var table = await ExamArrInit.examService.getExamList(
      const SchoolYear(2021),
      Semester.firstTerm,
    );
    // Log.info(table);
    print(table);
  });
}
