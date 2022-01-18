import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:kite/entity/expense.dart';
import 'package:kite/service/sso/sso_session.dart';

const String noticeSelector = 'table#table > tbody > tr';
const String dateSelector = 'td:nth-child(5) > div';
const String timeSelector = 'td:nth-child(7) > div';
const String amountSelector = 'td:nth-child(9) > div';
const String placeSelector = 'td:nth-child(11) > div';

class ExpenseService {
  static const _expenseUrl = 'http://card.sit.edu.cn/personalxiaofei.jsp';
  static const _typeKeywords = {
    '热水': ExpenseType.water,
    '浴室': ExpenseType.shower,
    '咖啡吧': ExpenseType.coffee,
    '食堂': ExpenseType.canteen,
    '超市': ExpenseType.store,
  };

  final SsoSession _session;

  const ExpenseService(this._session);

  Future<List<ExpenseDetail>> getExpenseBill(int page) async {
    final response = await _session.get(
      _expenseUrl,
      queryParameters: {
        'page': page.toString(),
      },
      responseType: ResponseType.plain,
    );
    return parseExpenseDetail(response.data);
  }

  static List<ExpenseDetail> parseExpenseDetail(String htmlPage) {
    final BeautifulSoup soup = BeautifulSoup(htmlPage);

    return soup.findAll(noticeSelector).map(parseExpenseItem).toList();
  }

  static ExpenseType _speculateType(String place) {
    ExpenseType result = ExpenseType.unknown;
    for (String key in _typeKeywords.keys) {
      if (place.contains(key)) {
        result = _typeKeywords[key]!;
        break;
      }
    }
    return result;
  }

  static ExpenseDetail parseExpenseItem(Bs4Element item) {
    if (item.findAll('th').isNotEmpty) {
      final String place = item.find(placeSelector)!.innerHtml.trim();
      final ExpenseType type = _speculateType(place);
      final String amount = item.find(amountSelector)!.innerHtml.trim();

      final String date = item.find(dateSelector)!.innerHtml.trim();
      final String time = item.find(timeSelector)!.innerHtml.trim();
      final DateTime ts = DateTime.parse('$date $time');

      return ExpenseDetail(place, ts, double.parse(amount), type);
    }
    throw Exception('消费记录解析失败.');
  }
}
