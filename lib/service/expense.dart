import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:enough_convert/gbk/gbk.dart';
import 'package:kite/dao/expense.dart';
import 'package:kite/entity/expense.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/service/abstract_session.dart';

class ExpenseRemoteService extends AService implements ExpenseRemoteDao {
  static const _expenseUrl = 'http://card.sit.edu.cn/personalxiaofei.jsp';
  static const _typeKeywords = {
    '热水': ExpenseType.water,
    '浴室': ExpenseType.shower,
    '咖啡吧': ExpenseType.coffee,
    '食堂': ExpenseType.canteen,
    '超市': ExpenseType.store,
  };
  static const _codec = GbkCodec();
  ExpenseRemoteService(ASession session) : super(session);

  @override
  Future<ExpensePage> getExpensePage(int page, {DateTime? start, DateTime? end}) async {
    start = start ?? DateTime(2010);
    end = end ?? DateTime.now();
    final response = await session.get(
      _expenseUrl,
      queryParameters: {
        'page': page.toString(),
        'from': _convert(start),
        'to': _convert(end),
      },
      responseType: ResponseType.bytes,
    );
    return _parseExpenseDetail(_codec.decode(response.data));
  }

  static ExpensePage _parseExpenseDetail(String htmlPage) {
    const String recordSelector = 'table#table > tbody > tr';

    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    // 先获取每一行,过滤首行
    final records = soup.findAll(recordSelector).sublist(1).map(_parseExpenseItem).toList();

    // 页号信息
    final pageInfo = soup.findAll('div', id: 'listContent')[1].text;
    String currentPage = RegExp(r'第(\S*)页').allMatches(pageInfo).first.group(1)!;
    String totalPage = RegExp(r'共(\S*)页').allMatches(pageInfo).first.group(1)!;

    return ExpensePage()
      ..records = records
      ..currentPage = int.parse(currentPage)
      ..total = int.parse(totalPage);
  }

  static String _convert(DateTime date) {
    final year = date.year.toString();
    var month = date.month.toString();
    var day = date.day.toString();
    if (month.length == 1) {
      month = '0$month';
    }
    if (day.length == 1) {
      day = '0$day';
    }
    return '$year$month$day';
  }

  /// 根据某地点计算其消费类型
  static ExpenseType _speculateType(String place) {
    return _typeKeywords.entries.firstWhere(
      (element) => place.contains(element.key),
      orElse: () {
        return const MapEntry('', ExpenseType.unknown);
      },
    ).value;
  }

  /// 解析每一条消费记录
  static ExpenseRecord _parseExpenseItem(Bs4Element item) {
    final cells = item.findAll('td').map((e) => e.text.trim()).toList();

    return ExpenseRecord()
      ..username = cells[0]
      ..name = cells[1]
      ..ts = DateTime.parse('${cells[2]} ${cells[3]}')
      ..amount = double.parse(cells[4])
      ..place = cells[5]
      ..type = _speculateType(cells[5]);
  }
}
