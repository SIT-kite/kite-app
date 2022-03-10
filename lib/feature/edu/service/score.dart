/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';
import '../dao/index.dart';
import '../entity/index.dart';


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
      'gnmkdm': 'N305005',
      'doType': 'query',
    }, data: {
      // 学年名
      'xnm': schoolYear.toString(),
      // 学期名
      'xqm': semesterToFormField(semester),
      // 获取成绩最大数量
      'queryModel.showCount': 100,
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

  static List<Score> _parseScoreListPage(Map<String, dynamic> jsonPage) {
    final List scoreList = jsonPage['items'];

    return scoreList.map((e) => Score.fromJson(e as Map<String, dynamic>)).toList();
  }

  static ScoreDetail _mapToDetailItem(Bs4Element item) {
    f1(s) => s.replaceAll('&nbsp;', '').replaceAll(' ', '');
    f2(s) => s.replaceAll('【', '').replaceAll('】', '');
    f(s) => f1(f2(s));

    String type = item.find(_scoreFormSelector)!.innerHtml.trim();
    String percentage = item.find(_scorePercentageSelector)!.innerHtml.trim();
    String value = item.find(_scoreValueSelector)!.innerHtml;

    return ScoreDetail(f(type), f(percentage), double.tryParse(f(value)) ?? double.nan);
  }

  static List<ScoreDetail> _parseDetailPage(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    final elements = soup.findAll(_scoreDetailPageSelector);

    return elements.map(_mapToDetailItem).toList();
  }
}
