
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/entity/sc/list.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/dao/sc/list.dart';
import 'package:kite/session/abstract_session.dart';

class ScActivityListService extends AService implements ScActivityListDao {
  static const _scActivityListUrl = "";

  static RegExp re = RegExp(r"(\d){7}");
  static String selector = ".ul_7 li > a";

  ScActivityListService(ASession session) : super(session);

  /// 获取第二课堂活动列表
  @override
  Future<List<Activity>> getActivityList() async{
    final response = await session.post(_scActivityListUrl);
    return _parseActivityList(response.data);
  }

  static List<Activity> _parseActivityList(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    List<Activity> result = [];
    soup.findAll(selector)
        .forEach((element) {
      String link = element.attributes['href']!;
      String? x = re.firstMatch(link)?.group(0).toString();
      int id = int.parse(x!);
      Activity newActivity = Activity(id, 0);
      result.add(newActivity);
    });
    return result;
  }
}

