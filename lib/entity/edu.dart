export 'edu/exam.dart';
export 'edu/score.dart';
export 'edu/timetable.dart';

enum Semester {
  all,
  firstTerm,
  secondTerm,
}

class SchoolYear {
  static const all = SchoolYear(null);
  final int? year;

  const SchoolYear(this.year);

  @override
  String toString() {
    return (year ?? '').toString();
  }
}
