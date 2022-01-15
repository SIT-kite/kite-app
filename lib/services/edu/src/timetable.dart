import 'dart:core';

import 'package:kite/services/abstract_session.dart';
import 'package:kite/services/edu/src/timetable_parser.dart';

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

class TimetableService {
  static const _timeTableUrl =
      'http://jwxt.sit.edu.cn/jwglxt/kbcx/xskbcx_cxXsgrkb.html';

  final ASession _session;

  const TimetableService(this._session);

  static String _semesterToRequestField(Semester semester) {
    return {
      Semester.all: '',
      Semester.firstTerm: '3',
      Semester.secondTerm: '12',
      Semester.midTerm: '16',
    }[semester]!;
  }

  /// 获取课表
  Future<List<Course>> getTimetable(
    SchoolYear schoolYear,
    Semester semester,
  ) async {
    var response = await _session.post(
      _timeTableUrl,
      queryParameters: {
        'gnmkdm': 'N253508',
        // 实测以下被注释的字段根本无用，又提高了耦合
        // 'su': _session.username!,
      },
      data: {
        // 学年名
        'xnm': schoolYear.toString(),
        // 学期名
        'xqm': _semesterToRequestField(semester),
      },
    );
    return parseTimetable(response.data);
  }
}
