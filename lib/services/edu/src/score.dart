import 'package:kite/services/edu/edu.dart';
import 'package:kite/services/edu/src/score_parser.dart';
import 'package:kite/services/sso/sso.dart';

class ScoreService {
  static const _scoreUrl =
      'http://jwxt.sit.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html';

  final ISession _session;

  const ScoreService(this._session);

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
    var response = await _session.post(
      _scoreUrl,
      queryParameters: {
        'qnmkdm': 'N305005',
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
    return parseScoreListPage(response.data);
  }
}
