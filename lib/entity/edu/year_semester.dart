enum Semester {
  all,
  firstTerm,
  secondTerm,
  midTerm,
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
