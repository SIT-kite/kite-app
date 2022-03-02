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
import 'package:intl/intl.dart';
import 'package:kite/entity/sc/list.dart';
import 'package:kite/entity/sc/score.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

import '../../dao/sc/score.dart';

class ScScoreService extends AService implements ScScoreDao {
  static const _scHomeUrl = 'http://sc.sit.edu.cn/public/init/index.action';
  static const _scScoreUrl = 'http://sc.sit.edu.cn/public/pcenter/scoreDetail.action';
  static const _scMyEventUrl = 'http://sc.sit.edu.cn/public/pcenter/activityOrderList.action';

  static const totalScore = '#content-box > div.user-info > div:nth-child(3) > font';
  static const spanScore = '#span_score';
  static const scoreDetailPage = '#div1 > div.table_style_4 > form > table:nth-child(7) > tbody > tr';
  static const idDetail = 'td:nth-child(7)';
  static const titleDetail = 'td:nth-child(1)';
  static const categoryDetail = 'td:nth-child(5)';
  static const scoreDetail = 'td:nth-child(11) > span';
  static const activityDetail = '#content-box > div:nth-child(23) > div.table_style_4 > form > table > tbody > tr';
  static const activityIdDetail = 'td:nth-child(3)';
  static const timeDetail = 'td:nth-child(7)';
  static const statusDetail = 'td:nth-child(9)';

  static final dateFormatParser = DateFormat('yyyy-MM-dd hh:mm:ss');
  static final activityIdRe = RegExp(r'activityId=(\d+)');

  ScScoreService(ASession session) : super(session);

  /// 获取第二课堂分数
  @override
  Future<ScScoreSummary> getScScoreSummary() async {
    final response = await session.post(_scHomeUrl);
    return _parseScScoreSummary(response.data);
  }

  static ScScoreSummary _parseScScoreSummary(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    final displayScoreList = soup.findAll(totalScore).map((e) => e.innerHtml).toList();

    // 学分=1.5(主题报告)+2.0(社会实践)+1.5(创新创业创意)+1.0(校园安全文明)+0.0(公益志愿)+2.0(校园文化)
    final String scoreText = soup.find(spanScore)!.innerHtml.toString();
    final regExp = RegExp(r'(\d+\.\d{0,2})(\w)');

    final matches = regExp.firstMatch(scoreText)!.groups([1, 2]);
    late final double lecture, practice, creation, safetyEdu, voluntary, campus;

    for (final item in matches) {
      final score = double.parse(item![0]);
      final type = stringToActivityScoreType[item[1].trim()]!;

      switch (type) {
        case ActivityScoreType.lecture:
          lecture = score;
          break;
        case ActivityScoreType.creation:
          creation = score;
          break;
        case ActivityScoreType.campus:
          campus = score;
          break;
        case ActivityScoreType.practice:
          practice = score;
          break;
        case ActivityScoreType.voluntary:
          voluntary = score;
          break;
        case ActivityScoreType.safetyEdu:
          safetyEdu = score;
          break;
      }
    }
    return ScScoreSummary(lecture, practice, creation, safetyEdu, voluntary, campus);
  }

  /// 获取我的得分列表
  @override
  Future<List<ScScoreItem>> getMyScoreList() async {
    final response = await session.post(_scScoreUrl);
    return _parseMyScoreList(response.data);
  }

  static List<ScScoreItem> _parseMyScoreList(String htmlPage) {
    ScScoreItem nodeToScoreItem(Bs4Element item) {
      final int id = int.parse(item.find(idDetail)!.innerHtml.trim());
      final String title = item.find(titleDetail)!.innerHtml.trim();
      // 注意：“我的成绩” 页面中，成绩条目显示的是活动类型，而非加分类型, 因此使用 ActivityType.
      final ActivityType category = stringToActivityType[item.find(categoryDetail)!.innerHtml.trim()]!;
      final double amount = double.parse(item.find(scoreDetail)!.innerHtml.trim());

      return ScScoreItem(id, title, category, amount);
    }

    // 得分列表里面，有一些条目加诚信分，此时常规得分为 0, 要把这些条目过滤掉。
    bool filterZeroScore(ScScoreItem item) => item.amount > 0.01;

    return BeautifulSoup(htmlPage).findAll(scoreDetailPage).map(nodeToScoreItem).where(filterZeroScore).toList();
  }

  /// 获取我的活动列表
  @override
  Future<List<ScActivityItem>> getMyActivityList() async {
    final response = await session.post(_scMyEventUrl);
    return _parseMyActivityList(response.data);
  }

  static List<ScActivityItem> _parseMyActivityList(String htmlPage) {
    ScActivityItem _activityMapDetail(Bs4Element item) {
      // 如：activityId=10000
      final activityIdText = item.find(activityIdDetail)!.innerHtml.trim();
      // 如：10000
      final activityIdString = activityIdRe.firstMatch(activityIdText)!.group(1)!;
      final activtiyId = int.parse(activityIdString);

      final DateTime time = dateFormatParser.parse(item.find(timeDetail)!.innerHtml.trim());
      final String status = item.find(statusDetail)!.innerHtml.trim();

      return ScActivityItem(activtiyId, time, status);
    }

    bool _filterDeletedActivity(ScActivityItem x) => x.activityId != 0;

    return BeautifulSoup(htmlPage)
        .findAll(activityDetail)
        .map((e) => _activityMapDetail(e))
        .where((element) => _filterDeletedActivity(element))
        .toList();
  }
}
