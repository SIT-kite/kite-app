import 'package:kite/service/expense/expense.dart';
import 'package:kite/service/expense/src/expense_detail_parser.dart';
import 'package:kite/service/sso/sso_session.dart';
import 'package:dio/dio.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';

String notice = 'table#table>tbody>tr';
String expensePlace = 'td:nth-child(11)>div';
String expenseDate = 'td:nth-child(5)>div';
String expenseTime = 'td:nth-child(7)>div';
String expenseMoney = 'td:nth-child(9)>div';

class ExpenseService {
  static const _expenseUrl = 'http://card.sit.edu.cn/personalxiaofei.jsp';
  final SsoSession _session;
  const ExpenseService(this._session);
  Future<List<ExpenseDetail>> getExpenseList(String page) async {
    var response = await _session.get(
      _expenseUrl,
      queryParameters: {
        'page': page,
      },
      responseType: ResponseType.bytes,
    );
    return parseExpenseDatail(response.data);
  }
}

class ExpenseDetail {
  // 消费地点
  String expenseDatailPlace = "";

  // 消费时间
  String expenseDatailDate = "";

  //  消费时间
  String expenseDatailTime = "";

  // 消费金额
  double expenseDatailMoney = 0.0;

  ExpenseDetail(
      this.expenseDatailPlace, this.expenseDatailDate, this.expenseDatailMoney);

  @override
  String toString() {
    return '{expensePlace: $expenseDatailPlace, expenseDate: $expenseDatailDate, expenseMoney: $expenseDatailMoney}';
  }

  static double _stringToDouble(String s) => double.tryParse(s) ?? -1.0;

  static ExpenseDetail _expenseDetailMap(Bs4Element item) {
    String expenseDatilPlace = '';
    String expenseDatailDate = '';
    double expenseDatailMoney = 0.0;
    if (item.findAll('th').length == 0) {
      expenseDatilPlace = item
          .findAll(expensePlace)
          .map((e) => e.innerHtml.trim())
          .elementAt(0);
      expenseDatailDate =
          item.findAll(expenseDate).map((e) => e.innerHtml.trim()).elementAt(0);
      expenseDatailMoney = item
          .findAll(expenseMoney)
          .map((e) => _stringToDouble(e.innerHtml.trim()))
          .elementAt(0);
    }
    return ExpenseDetail(
        expenseDatilPlace, expenseDatailDate, expenseDatailMoney);
  }
}

List<ExpenseDetail> parseExpenseDatail(String htmlPage) {
  List<ExpenseDetail> resultList = [];
  final soup = BeautifulSoup(htmlPage);
  var x = soup.findAll(notice);
  for (var newExpenseDetail in x) {
    var newExpense = ExpenseDetail._expenseDetailMap(newExpenseDetail);
    resultList.add(newExpense);
  }
  print(resultList);
  return resultList;
}
