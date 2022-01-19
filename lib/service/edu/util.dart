import 'package:kite/entity/edu.dart';

String semesterToFormField(Semester semester) {
  const mapping = {
    Semester.all: '',
    Semester.firstTerm: '3',
    Semester.secondTerm: '12',
  };
  return mapping[semester]!;
}
