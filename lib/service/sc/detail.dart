import 'dart:collection';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:intl/intl.dart';
import 'package:kite/dao/sc/detail.dart';
import 'package:kite/entity/sc/detail.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

class ScActivityDetailService extends AService implements ScActivityDetailDao {
  static const _scDetailUrlBase = 'http://sc.sit.edu.cn/public/activity/activityDetail.action?activityId=';

  static RegExp reSpaces = RegExp(r'\s{2}\s+');
  static String selectorFrame = '.box-1';
  static String selectorTitle = 'h1';
  static String selectorBanner = 'div[style=\" color:#7a7a7a; text-align:center"]';
  static String selectorDescription = 'div[style="padding:30px 50px; font-size:14px;"]';

  ScActivityDetailService(ASession session) : super(session);

  /// 获取第二课堂活动详情
  @override
  Future<ActivityDetail> getActivityDetail(int activityId) async {
    final response = await session.post(_scDetailUrlBase + activityId.toString());
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
