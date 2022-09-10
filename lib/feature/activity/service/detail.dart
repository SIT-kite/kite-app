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

import 'dart:collection';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:intl/intl.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';

import '../dao/detail.dart';
import '../entity/detail.dart';

class ScActivityDetailService extends AService implements ScActivityDetailDao {
  static const _scDetailUrlBase = 'http://sc.sit.edu.cn/public/activity/activityDetail.action?activityId=';

  static RegExp reSpaces = RegExp(r'\s{2}\s+');
  static String selectorFrame = '.box-1';
  static String selectorTitle = 'h1';
  static String selectorBanner = 'div[style=" color:#7a7a7a; text-align:center"]';
  static String selectorDescription = 'div[style="padding:30px 50px; font-size:14px;"]';

  ScActivityDetailService(ISession session) : super(session);

  /// 获取第二课堂活动详情
  @override
  Future<ActivityDetail> getActivityDetail(int activityId) async {
    final response = await session.request(_scDetailUrlBase + activityId.toString(), RequestMethod.post);
    return _parseActivityDetail(response.data);
  }

  static String _cleanText(String banner) {
    String result = banner.replaceAll('&nbsp;', ' ').replaceAll('<br>', '');
    return result.replaceAll(reSpaces, '\n');
  }

  static HashMap<String, String> _splitActivityProperties(String banner) {
    String cleanText = _cleanText(banner);
    List<String> lines = cleanText.split('\n');
    lines.removeLast();
    HashMap<String, String> map = HashMap<String, String>();
    for (String line in lines) {
      List<String> result = line.split('：');
      map.addAll({result[0]: result[1]});
    }
    return map;
  }

  static DateTime _parseDateTime(String dateTime) {
    var dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
    return dateFormat.parse(dateTime);
  }

  static List<DateTime> _parseSignTime(String value) {
    List<String> time = value.split('  --至--  ');
    return [_parseDateTime(time[0]), _parseDateTime(time[1])];
  }

  static ActivityDetail _parseProperties(Bs4Element item) {
    String title = item.findAll(selectorTitle).map((e) => e.innerHtml.trim()).elementAt(0);
    String description = item.findAll(selectorDescription).map((e) => e.innerHtml.trim()).elementAt(0);
    String banner = item.findAll(selectorBanner).map((e) => e.innerHtml.trim()).elementAt(0);

    final properties = _splitActivityProperties(banner);
    final signTime = _parseSignTime(properties['刷卡时间段']!);

    return ActivityDetail(
        int.parse(properties['活动编号']!),
        0,
        title,
        _parseDateTime(properties['活动开始时间']!),
        signTime[0],
        signTime[1],
        properties['活动地点'],
        properties['活动时长'],
        properties['负责人'],
        properties['负责人电话'],
        properties['主办方'],
        properties['承办方'],
        description);
  }

  static ActivityDetail _parseActivityDetail(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    final frame = soup.find(selectorFrame);
    final detail = _parseProperties(frame!);

    return detail;
  }
}
