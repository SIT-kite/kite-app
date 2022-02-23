import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:format/format.dart';
import 'package:intl/intl.dart';
import 'package:kite/entity/sc/score.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

import '../../dao/sc/score.dart';

class ScScoreService extends AService implements ScScoreDao {
  static const _scScoreUrl = '';

  static List<String> classification = ['主题报告', '社会实践', '创新创业创意', '校园安全文明', '公益志愿', '校园文化'];

  static String totalScore = '#content-box > div.user-info > div:nth-child(3) > font';
  static String spanScore = '#span_score';
  static String scoreDetailPage = '#div1 > div.table_style_4 > form > table:nth-child(7) > tbody > tr';
  static String idDetail = 'td:nth-child(7)';
  static String categoryDetail = 'td:nth-child(5)';
  static String scoreDetail = 'td:nth-child(11) > span';
  static String activityDetail = '#content-box > div:nth-child(23) > div.table_style_4 > form > table > tbody > tr';
  static String activityIdDetail = 'td:nth-child(3)';
  static String timeDetail = 'td:nth-child(7)';
  static String statusDetail = 'td:nth-child(9)';

  static RegExp activityIdRe = RegExp(r'activityId=(\d+)');

  ScScoreService(ASession session) : super(session);

  /// 获取第二课堂分数
  @override
  Future<ScScoreSummary> getScScoreSummary() async {
    final response = await session.post(_scScoreUrl);
    return _parseScScoreSummary(response.data);
  }

  static ScScoreSummary _from(List<String> fields) {
    List<double> mappedList = [];
    for (var element in fields) {
      var elementD = double.parse(element);
      mappedList.add(elementD);
    }
    return ScScoreSummary(mappedList[0], mappedList[1], mappedList[2], mappedList[3], mappedList[4], mappedList[5],
        mappedList[6], mappedList[7], mappedList[8]);
  }

  static List<RegExp> _getScoreSummaryRegex() {
    List<RegExp> result = [];
    for (var classes in classification) {
      var reg = format('(\\d+\\.\\d{0,2})\\({}\\)', classes);
      var newRegex = RegExp(reg);
      result.add(newRegex);
    }
    return result;
  }

  static ScScoreSummary _parseScScoreSummary(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    var displayScoreList = soup.findAll(totalScore).map((e) => e.innerHtml).toList();
    String? hideScoreText = soup.find(spanScore)?.innerHtml.toString();
    List<RegExp> scoreSummaryRegex = _getScoreSummaryRegex();
    List<String> hideScoreList = [];

    for (var scoreSummary in scoreSummaryRegex) {
      var x = scoreSummary.firstMatch(hideScoreText!);
      String? newScore = x?.group(1).toString();
      hideScoreList.add(newScore!);
    }

    displayScoreList.addAll(hideScoreList);

    return _from(displayScoreList);
  }

  /// 获取我的得分列表
  @override
  Future<List<ScScoreItem>> getMyScoreList() async {
    final response = await session.post(_scScoreUrl);
    return _parseMyScoreList(response.data);
  }

  static int _transCategoryToInt(String x) {
    switch (x) {
      case '校园文化活动':
        return 8;
      case '创新创业创意':
        return 3;
      case '主题教育':
        return 7;
      case '讲座报告':
        return 1;
      case '志愿公益':
        return 5;
      case '安全教育网络教学':
        return 9;
      case '社会实践':
        return 2;
      case '校园文明':
        return 4;
      case '社团社区易班、学院活动':
        return 8;
      default:
        return 0;
    }
  }

  static ScScoreItem _scoreMapDetail(Bs4Element item) {
    int id = item.findAll(idDetail).map((e) => int.parse(e.innerHtml.trim())).elementAt(0);
    int category = item.findAll(categoryDetail).map((e) => _transCategoryToInt(e.innerHtml.trim())).elementAt(0);
    double addScore = item.findAll(scoreDetail).map((e) => double.parse(e.innerHtml.trim())).elementAt(0);

    return ScScoreItem(id, category, addScore);
  }

  static bool _filterZeroScore(ScScoreItem x) {
    return (x.amount > 0.01);
  }

  static List<ScScoreItem> _parseMyScoreList(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    var scoreItems = soup
        .findAll(scoreDetailPage)
        .map((e) => _scoreMapDetail(e))
        .where((element) => _filterZeroScore(element))
        .toList();

    Map<int, int> map1 = {};
    Map<int, double> map2 = {};

    for (var s in scoreItems) {
      map1[s.activityId] = s.category;
      if (map2.containsKey(s.activityId)) {
        var old = map2[s.activityId]!;
        var newAmount = old + s.amount;
        map2[s.activityId] = newAmount;
      } else {
        map2[s.activityId] = s.amount;
      }
    }

    List<ScScoreItem> newScoreItems = [];
    map2.forEach((key, value) {
      var newItem = ScScoreItem(key, map1[key]!, value);
      newScoreItems.add(newItem);
    });

    return newScoreItems;
  }

  /// 获取我的活动列表
  @override
  Future<List<ScActivityItem>> getMyActivityList() async {
    final response = await session.post(_scScoreUrl);
    return _parseMyActivityList(response.data);
  }

  static ScActivityItem _activityMapDetail(Bs4Element item) {
    var dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
    var activityId = item.findAll(activityIdDetail).map((e) => e.innerHtml.trim()).elementAt(0);
    var reId = activityIdRe.firstMatch(activityId);
    int id = 0;
    if (reId != null) {
      id = int.parse(reId.group(1).toString());
    }
    DateTime time = item.findAll(timeDetail).map((e) => dateFormat.parse(e.innerHtml.trim())).elementAt(0);

    String status = item.findAll(statusDetail).map((e) => e.innerHtml.trim()).elementAt(0);

    return ScActivityItem(id, time, status);
  }

  static bool _filterDeleteActivity(ScActivityItem x) {
    return (x.activityId != 0);
  }

  static List<ScActivityItem> _parseMyActivityList(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    var result = soup
        .findAll(activityDetail)
        .map((e) => _activityMapDetail(e))
        .where((element) => _filterDeleteActivity(element))
        .toList();
    return result;
  }
}
