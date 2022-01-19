import 'dart:convert';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/dao/edu.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/service/abstract_session.dart';

import 'util.dart';

class ScoreService extends AService implements ScoreDao {
  static const _scoreUrl = 'http://jwxt.sit.edu.cn/jwglxt/cjcx/cjcx_cxDgXscj.html';
  static const _scoreDetailUrl = 'http://jwxt.sit.edu.cn/jwglxt/cjcx/cjcx_cxCjxqGjh.html';

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
  static const _scoreDetailPageSelector = "div.table-responsive > #subtab > tbody > tr";
  static const _scoreFormSelector = "td:nth-child(1)";
  static const _scorePercentageSelector = "td:nth-child(3)";
  static const _scoreValueSelector = "td:nth-child(5)";

  ScoreService(ASession session) : super(session);

  /// 获取成绩
  @override
  Future<List<Score>> getScoreList(SchoolYear schoolYear, Semester semester) async {
    final response = await session.post(_scoreUrl, queryParameters: {
      'gnmkdm': 'N305005'
    }, data: {
      // 学年名
      'xnm': schoolYear.toString(),
      // 学期名
      'xqm': semesterToFormField(semester)
    });
    return _parseScoreListPage(response.data);
  }

  /// 获取成绩详情
  @override
  Future<List<ScoreDetail>> getScoreDetail(String classId, SchoolYear schoolYear, Semester semester) async {
    var response = await session.post(
      _scoreDetailUrl,
      queryParameters: {'gnmkdm': 'N305005'},
      data: {
        // 班级
        'jxb_id': classId,
        // 学年名
        'xnm': schoolYear.toString(),
        // 学期名
        'xqm': semesterToFormField(semester)
      },
    );
    return _parseDetailPage(response.data);
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

  static ScoreDetail _mapToDetailItem(Bs4Element item) {
    f1(s) => s.replaceAll("&nbsp;", "");
    f2(s) => s.replaceAll("【 ", "").replaceAll(" 】", "");

    String type = item.find(_scoreFormSelector)!.innerHtml.trim();
    String percentage = item.find(_scorePercentageSelector)!.innerHtml.trim();
    double value = double.tryParse(item.find(_scoreValueSelector)!.innerHtml) ?? -1;

    return ScoreDetail(scoreType: f1(type), percentage: f2(percentage), value: value);
  }

  static List<ScoreDetail> _parseDetailPage(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    final elements = soup.findAll(_scoreDetailPageSelector);

    return elements.map(_mapToDetailItem).toList();
  }
}
