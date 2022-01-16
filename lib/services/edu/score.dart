import 'dart:convert';

import 'package:kite/entity/edu/score.dart';
import 'package:kite/entity/edu/year_semester.dart';
import 'package:kite/services/abstract_service.dart';
import 'package:kite/services/abstract_session.dart';

class ScoreService extends AService {
  static const _scoreUrl =
      'http://jwxt.sit.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html';

  ScoreService(ASession session) : super(session);

  static String _semesterToRequestField(Semester semester) {
    return {
      Semester.all: '',
      Semester.firstTerm: '3',
      Semester.secondTerm: '12',
      Semester.midTerm: '16',
    }[semester]!;
  }

  /// 获取成绩
  Future<List<Score>> getScoreList(
    SchoolYear schoolYear,
    Semester semester,
  ) async {
    var response = await session.post(
      _scoreUrl,
      queryParameters: {
        'gnmkdm': 'N305005',
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
    return _parseScoreListPage(response.data);
  }

  static List<Score> _parseScoreListPage(String page) {
    var jsonPage = jsonDecode(page);
    List<Score> result = [];
    for (var score in jsonPage["items"]) {
      Score newScore = Score();
      newScore = Score.fromJson(score);
      result.add(newScore);
    }
    return result;
  }
}
