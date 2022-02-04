import 'package:kite/entity/edu/index.dart';

String semesterToFormField(Semester semester) {
  const mapping = {
    Semester.all: '',
    Semester.firstTerm: '3',
    Semester.secondTerm: '12',
  };
  return mapping[semester]!;
}

Semester formFieldToSemester(String s) {
  Map<String, Semester> semester = {
    '': Semester.all,
    '3': Semester.firstTerm,
    '12': Semester.secondTerm,
  };
  return semester[s]!;
}

SchoolYear formFieldToSchoolYear(String s) {
  final year = int.parse(s.split('-')[0]);
  return SchoolYear(year);
}

String schoolYearToFormField(SchoolYear y) {
  if (y.year != null) {
    return '${y.year!}-${y.year! + 1}';
  }
  return '';
}

double stringToDouble(String s) => double.tryParse(s) ?? double.nan;
