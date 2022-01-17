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
  final int? _year;

  const SchoolYear(this._year);

  @override
  String toString() {
    return (_year ?? '').toString();
  }
}
