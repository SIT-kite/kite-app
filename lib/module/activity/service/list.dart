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
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:kite/module/activity/page/util.dart';

import '../dao/list.dart';
import '../entity/list.dart';
import '../using.dart';

class ScActivityListService implements ScActivityListDao {
  static const _scActivityType = {
    ActivityType.schoolCulture: '8ab17f543fe626a8013fe6278a880001',
    ActivityType.creation: 'ff8080814e241104014eb867e1481dc3',
    ActivityType.lecture: '001',
    ActivityType.practice: '8ab17f543fe62d5d013fe62efd3a0002',
    ActivityType.thematicEdu: 'ff808081674ec4720167ce60dda77cea',
    ActivityType.voluntary: '8ab17f543fe62d5d013fe62e6dc70001',
  };
  static RegExp re = RegExp(r"(\d){7}");
  static String selector = '.ul_7 li > a';
  static DateFormat dateFormatParser = DateFormat('yyyy-MM-dd hh:mm:ss');

  static bool _initializedCookie = false;

  final ISession session;

  const ScActivityListService(this.session);

  Future<void> _refreshCookie() async {
    Future<void> getHomePage() async {
      const String url = 'http://sc.sit.edu.cn/';
      await session.request(url, ReqMethod.get);
    }

    if (!_initializedCookie) {
      await getHomePage();
      _initializedCookie = true;
    }
  }

  /// 获取第二课堂活动列表
  @override
  Future<List<Activity>> getActivityList(ActivityType type, int page) async {
    String generateUrl(ActivityType category, int page, [int pageSize = 20]) {
      return 'http://sc.sit.edu.cn/public/activity/activityList.action?pageNo=$page&pageSize=$pageSize&categoryId=${_scActivityType[category]}';
    }

    await _refreshCookie();
    final url = generateUrl(type, page);
    final response = await session.request(url, ReqMethod.get);

    return _parseActivityList(response.data);
  }

  @override
  Future<List<Activity>> query(String queryString) async {
    const String url = 'http://sc.sit.edu.cn/public/activity/activityList.action';

    await _refreshCookie();
    final response = await session.request(
      url,
      ReqMethod.post,
      data: 'activityName=$queryString',
      options: SessionOptions(contentType: Headers.formUrlEncodedContentType),
    );

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
        final titleAndTags = splitTitleAndTags(title);
        return Activity(
            id: id,
            category: ActivityType.unknown,
            title: title,
            ts: dateFormatParser.parse(date),
            realTitle: titleAndTags.item1,
            tags: titleAndTags.item2);
      },
    ).toList();
    return result;
  }
}
