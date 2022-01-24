import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:enough_convert/gbk/gbk.dart';
import 'package:intl/intl.dart';
import 'package:kite/dao/expense.dart';
import 'package:kite/entity/expense.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/service/abstract_session.dart';
import 'package:kite/global/storage_pool.dart';

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
  Future<ExpensePage> getExpensePage(bool refresh, int page,
      {DateTime? start, DateTime? end}) async {
    start = start ?? DateTime(2010);
    end = end ?? DateTime.now();
    final response = await session.get(
      _expenseUrl,
      queryParameters: {
        'page': page.toString(),
        'from': _dateToString(start),
        'to': _dateToString(end),
      },
      responseType: ResponseType.bytes,
    );
    return _parseExpenseDetail(refresh, _codec.decode(response.data));
  }

  static ExpensePage _parseExpenseDetail(bool refresh, String htmlPage) {
    const String recordSelector = 'table#table > tbody > tr';

    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    // 先获取每一行,过滤首行
    List<ExpenseRecord> records = [];
    if (refresh) {
      for (final bill in soup.findAll(recordSelector).sublist(1)) {
        if (_parseExpenseItem(bill).ts !=
            StoragePool.expenseRecordStorage.getAllByTimeDesc()[0].ts) {
          records.add(_parseExpenseItem(bill));
          StoragePool.expenseRecordStorage.add(_parseExpenseItem(bill));
        } else {
          break;
        }
      }
    } else {
      for (final bill in soup.findAll(recordSelector).sublist(1)) {
        records.add(_parseExpenseItem(bill));
        StoragePool.expenseRecordStorage.add(_parseExpenseItem(bill));
      }
    }
    // 页号信息
    final pageInfo = soup.findAll('div', id: 'listContent')[1].text;
    String currentPage =
        RegExp(r'第(\S*)页').allMatches(pageInfo).first.group(1)!;
    String totalPage = RegExp(r'共(\S*)页').allMatches(pageInfo).first.group(1)!;

    return ExpensePage()
      ..records = records
      ..currentPage = int.parse(currentPage)
      ..total = int.parse(totalPage);
  }

  static String _dateToString(DateTime date) {
    return DateFormat('yyyyMMdd').format(date);
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
