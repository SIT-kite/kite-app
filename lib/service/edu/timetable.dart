import 'dart:core';

import 'package:kite/entity/edu.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/service/abstract_session.dart';

class TimetableService extends AService {
  static const _timeTableUrl = 'http://jwxt.sit.edu.cn/jwglxt/kbcx/xskbcx_cxXsgrkb.html';

  TimetableService(ASession session) : super(session);

  static String _semesterToRequestField(Semester semester) {
    return {
      Semester.all: '',
      Semester.firstTerm: '3',
      Semester.secondTerm: '12',
    }[semester]!;
  }

  static List<Course> _parseTimetable(Map<String, dynamic> json) {
    List<Course> result = [];
    for (var course in json["kbList"]) {
      Course newCourse = Course();
      newCourse = Course.fromJson(course);
      result.add(newCourse);
    }
    return result;
  }

  /// 获取课表
  Future<List<Course>> getTimetable(
    SchoolYear schoolYear,
    Semester semester,
  ) async {
    var response = await session.post(
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
    return _parseTimetable(response.data);
  }
}
