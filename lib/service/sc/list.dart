import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:intl/intl.dart';
import 'package:kite/dao/sc/list.dart';
import 'package:kite/entity/sc/list.dart';
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
        final String title = element.text;
        final String link = element.attributes['href']!;

        final String? x = re.firstMatch(link)?.group(0).toString();
        final int id = int.parse(x!);

        return Activity(id, ActivityType.unknown, title, dateFormatParser.parse(date));
      },
    ).toList();
    return result;
  }
}
