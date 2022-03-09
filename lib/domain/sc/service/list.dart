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
import 'package:kite/domain/sc/dao/list.dart';
import 'package:kite/domain/sc/entity/list.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

class ScActivityListService extends AService implements ScActivityListDao {
  static const _scActivityType = {
    ActivityType.campus: '8ab17f543fe626a8013fe6278a880001',
    ActivityType.creation: 'ff8080814e241104014eb867e1481dc3',
    ActivityType.lecture: '001',
    ActivityType.practice: '8ab17f543fe62d5d013fe62efd3a0002',
    ActivityType.theme: 'ff808081674ec4720167ce60dda77cea',
    ActivityType.voluntary: '8ab17f543fe62d5d013fe62e6dc70001',
  };

  static RegExp re = RegExp(r"(\d){7}");
  static String selector = ".ul_7 li > a";
  static DateFormat dateFormatParser = DateFormat('yyyy-MM-dd hh:mm:ss');

  ScActivityListService(ASession session) : super(session);

  /// 获取第二课堂活动列表date
  @override
  Future<List<Activity>> getActivityList(ActivityType type, int page) async {
    String _generateUrl(ActivityType category, int page, [int pageSize = 20]) {
      return 'http://sc.sit.edu.cn/public/activity/activityList.action?pageNo=$page&pageSize=$pageSize&categoryId=${_scActivityType[category]}';
    }

    final url = _generateUrl(type, page);
    final response = await session.get(url);

    return _parseActivityList(response.data);
  }

  @override
  Future<List<Activity>> query(String queryString) async {
    const String url = 'http://sc.sit.edu.cn/public/activity/activityList.action';
    final response = await session.post(url, data: {'activityName': queryString});

    return _parseActivityList(response.data);
  }

  static List<Activity> _parseActivityList(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    List<Activity> result = soup.findAll(selector).map(
      (element) {
        final date = element.nextSibling!.text;
        final String title = element.text.substring(2);
        final String link = element.attributes['href']!;

        final String? x = re.firstMatch(link)?.group(0).toString();
        final int id = int.parse(x!);

        return Activity(id, ActivityType.unknown, title, dateFormatParser.parse(date));
      },
    ).toList();
    return result;
  }
}
