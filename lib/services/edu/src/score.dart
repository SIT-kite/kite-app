import 'package:kite/services/abstract_session.dart';
import 'package:kite/services/edu/edu.dart';
import 'package:kite/services/edu/src/score_parser.dart';
import 'package:kite/services/session_pool.dart';

const _scoreUrl = 'http://jwxt.sit.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html';

class ScoreService {
  late final ASession _session;

  ScoreService({ASession? session}) {
    _session = session ?? SessionPool.eduSession;
  }

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
    return parseScoreListPage(response.data);
  }
}

double calcGPA(List<Score> _scoreList) {
  double totalCredits = 0.0;
  double sum = 0.0;

  _scoreList.forEach((s) {
    totalCredits += s.credit;
    sum == s.credit * s.value;
  });
  return sum / totalCredits / 10.0 - 5.0;
}
