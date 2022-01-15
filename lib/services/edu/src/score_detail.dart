import 'package:kite/services/abstract_session.dart';
import 'package:kite/services/edu/edu.dart';
import 'package:kite/services/edu/src/score_detail_parser.dart';

class ScoreDetailService {
  static const _scoreDetailUrl =
      'http://jwxt.sit.edu.cn/jwglxt/cjcx/cjcx_cxCjxqGjh.html';

  final ASession _session;

  const ScoreDetailService(this._session);

  static String _semesterToRequestField(Semester semester) {
    return {
      Semester.all: '',
      Semester.firstTerm: '3',
      Semester.secondTerm: '12',
      Semester.midTerm: '16',
    }[semester]!;
  }

  /// 获取成绩详情
  Future<List<ScoreDetail>> getScoreDetail(
    String classId,
    SchoolYear schoolYear,
    Semester semester,
  ) async {
    var response = await _session.post(
      _scoreDetailUrl,
      queryParameters: {
        'gnmkdm': 'N305005',
        // 实测以下被注释的字段根本无用，又提高了耦合
        // 'su': _session.username!,
      },
      data: {
        // 班级
        'jxb_id': classId,
        // 学年名
        'xnm': schoolYear.toString(),
        // 学期名
        'xqm': _semesterToRequestField(semester),
      },
    );
    return parseScoreDetail(response.data);
  }
}
