import 'package:beautiful_soup_dart/beautiful_soup.dart';

String scoreDetailPage = "div.table-responsive > #subtab > tbody > tr";

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

String scoreForm = "td:nth-child(1)";
String scorePercentage = "td:nth-child(3)";
String scoreNumber = "td:nth-child(5)";

class ScoreDetail {
  // 成绩名称
  String scoreType = "";

  // 百分比
  String percentage = "";

  // 总评
  double score = 0.0;

  ScoreDetail(this.scoreType, this.percentage, this.score);

  @override
  String toString() {
    return 'ScoreDetail{scoreType: $scoreType, percentage: $percentage, score: $score}';
  }

  static String _replaceNbsp(String s) => s.replaceAll("&nbsp;", "");

  static String _replaceCurlyBrackets(String s) =>
      s.replaceAll("【 ", "").replaceAll(" 】", "");

  static double _stringToDouble(String s) => double.tryParse(s) ?? -1.0;

  static ScoreDetail _scoreDetailMap(Bs4Element item) {
    String scoreDetailType = item
        .findAll(scoreForm)
        .map((e) => _replaceCurlyBrackets(e.innerHtml.trim()))
        .elementAt(0);
    String scoreDetailPercentage = item
        .findAll(scorePercentage)
        .map((e) => _replaceNbsp(e.innerHtml.trim()))
        .elementAt(0);
    double scoreDetail = item
        .findAll(scoreNumber)
        .map((e) => _stringToDouble(_replaceNbsp(e.innerHtml.trim())))
        .elementAt(0);
    return ScoreDetail(scoreDetailType, scoreDetailPercentage, scoreDetail);
  }
}

List<ScoreDetail> getScoreDetail(String htmlPage) {
  final BeautifulSoup soup = BeautifulSoup(htmlPage);
  List<ScoreDetail> result = [];
  var scoreDetailList = soup.findAll(scoreDetailPage);
  for (var newScoreDetail in scoreDetailList) {
    var newScore = ScoreDetail._scoreDetailMap(newScoreDetail);
    result.add(newScore);
  }
  return result;
}
