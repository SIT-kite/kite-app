import 'dart:core';

import 'package:kite/dao/edu/index.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

import 'util.dart';

class TimetableService extends AService implements TimetableDao {
  static const _timeTableUrl = 'http://jwxt.sit.edu.cn/jwglxt/kbcx/xskbcx_cxXsgrkb.html';

  TimetableService(ASession session) : super(session);

  static List<Course> _parseTimetable(Map<String, dynamic> json) {
    final List<dynamic> courseList = json["kbList"];

    return courseList.map((e) => Course.fromJson(e)).toList();
  }

  /// 获取课表
  @override
  Future<List<Course>> getTimetable(SchoolYear schoolYear, Semester semester) async {
    final response = await session.post(
      _timeTableUrl,
      queryParameters: {'gnmkdm': 'N253508'},
      data: {
        // 学年名
        'xnm': schoolYear.toString(),
        // 学期名
        'xqm': semesterToFormField(semester)
      },
    );
    return _parseTimetable(response.data);
  }
}
