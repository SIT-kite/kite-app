import 'dart:convert';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/services/abstract_service.dart';
import 'package:kite/services/abstract_session.dart';

class ScoreService extends AService {
  static const _scoreUrl = 'http://jwxt.sit.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html';

  ScoreService(ASession session) : super(session);

  static String _semesterToRequestField(Semester semester) {
    return {
      Semester.all: '',
      Semester.firstTerm: '3',
      Semester.secondTerm: '12',
    }[semester]!;
  }

  /// 获取成绩
  Future<List<Score>> getScoreList(
    SchoolYear schoolYear,
    Semester semester,
  ) async {
    final response = await session.post(
      _scoreUrl,
      queryParameters: {
        'gnmkdm': 'N305005',
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

// 解析代码比较复杂，本类仅当命名空间使用，最后提供一个公开的方法
class _ScoreDetailParser {
  static const _scoreDetailPage = "div.table-responsive > #subtab > tbody > tr";

/* Why there child is 1,3,5 not 1,2,3?
  The example likes follow:
        <tr>
            <td valign="middle">【 平时 】</td>
            <td valign="middle">40%&nbsp;</td>
            <td valign="middle">77.5&nbsp;</td>
        </tr>
  When you use 1,2,3 to choose the <td>, you will get [] by 2,
  it's because /n is chosen by 2 in dart,so here use 1,3,5 to choose <td>
*/

  static const _scoreForm = "td:nth-child(1)";
  static const _scorePercentage = "td:nth-child(3)";
  static const _scoreNumber = "td:nth-child(5)";

  static String _replaceNbsp(String s) => s.replaceAll("&nbsp;", "");

  static String _replaceCurlyBrackets(String s) => s.replaceAll("【 ", "").replaceAll(" 】", "");

  static double _stringToDouble(String s) => double.tryParse(s) ?? -1.0;

  static ScoreDetail _scoreDetailMap(Bs4Element item) {
    String scoreDetailType =
        item.findAll(_scoreForm).map((e) => _replaceCurlyBrackets(e.innerHtml.trim())).elementAt(0);
    String scoreDetailPercentage =
        item.findAll(_scorePercentage).map((e) => _replaceNbsp(e.innerHtml.trim())).elementAt(0);
    double scoreDetail =
        item.findAll(_scoreNumber).map((e) => _stringToDouble(_replaceNbsp(e.innerHtml.trim()))).elementAt(0);

    return ScoreDetail(
      scoreType: scoreDetailType,
      percentage: scoreDetailPercentage,
      value: scoreDetail,
    );
  }

  static List<ScoreDetail> parseScoreDetail(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    List<ScoreDetail> result = [];
    var scoreDetailList = soup.findAll(_scoreDetailPage);
    for (var newScoreDetail in scoreDetailList) {
      var newScore = _scoreDetailMap(newScoreDetail);
      result.add(newScore);
    }
    return result;
  }
}

class ScoreDetailService extends AService {
  static const _scoreDetailUrl = 'http://jwxt.sit.edu.cn/jwglxt/cjcx/cjcx_cxCjxqGjh.html';

  ScoreDetailService(ASession session) : super(session);

  static String _semesterToRequestField(Semester semester) {
    return {
      Semester.all: '',
      Semester.firstTerm: '3',
      Semester.secondTerm: '12',
    }[semester]!;
  }

  /// 获取成绩详情
  Future<List<ScoreDetail>> getScoreDetail(
    String classId,
    SchoolYear schoolYear,
    Semester semester,
  ) async {
    var response = await session.post(
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
    return _ScoreDetailParser.parseScoreDetail(response.data);
  }
}
