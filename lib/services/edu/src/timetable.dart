import 'dart:core';

import 'package:kite/services/edu/src/timetable_parser.dart';
import 'package:kite/services/sso/src/session.dart';

class Timetable {
  static const _timeTableUrl =
      'http://jwxt.sit.edu.cn/jwglxt/kbcx/xskbcx_cxXsgrkb.html';

  final Session _session;

  const Timetable(this._session);

  /// 获取课表
  Future<List<Course>> getTimetable() async {
    var response = await _session.post(
      _timeTableUrl,
      queryParameters: {
        'gnmkdm': '',
        'su': _session.username!,
      },
      data: {
        // 学年名
        'xnm': 2021,
        // 学期名
        'xqm': 3,
        'kzlx': 'ck',
      },
    );
    return parseTimetable(response.data);
  }
}
