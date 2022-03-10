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
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:enough_convert/gbk/gbk.dart';
import 'package:intl/intl.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';

import '../dao/expense.dart';
import '../entity/expense.dart';
import '../init.dart';

class ExpenseRemoteService extends AService implements ExpenseRemoteDao {
  static const _expenseUrl = 'http://card.sit.edu.cn/personalxiaofei.jsp';
  static const _typeKeywords = {
    '开水': ExpenseType.water,
    '浴室': ExpenseType.shower,
    '咖啡吧': ExpenseType.coffee,
    '食堂': ExpenseType.canteen,
    '超市': ExpenseType.store,
  };
  static const _codec = GbkCodec();

  ExpenseRemoteService(ASession session) : super(session);

  @override
  Future<OaExpensePage> getExpensePage(
    int page, {
    required DateTime start,
    required DateTime end,
  }) async {
    final response = await session.get(
      _expenseUrl,
      queryParameters: {
        'page': page.toString(),
        'from': _dateToString(start),
        'to': _dateToString(end),
      },
      responseType: ResponseType.bytes,
    );

    return _parseExpenseDetail(_codec.decode(response.data));
  }

  static OaExpensePage _parseExpenseDetail(String htmlPage) {
    const String recordSelector = 'table#table > tbody > tr';

    final BeautifulSoup soup = BeautifulSoup(htmlPage);
    // 先获取每一行,过滤首行
    List<ExpenseRecord> records = [];
    for (final bill in soup.findAll(recordSelector).sublist(1)) {
      records.add(_parseExpenseItem(bill));
      ExpenseInitializer.expenseRecord.add(_parseExpenseItem(bill));
    }
    // 页号信息
    final pageInfo = soup.findAll('div', id: 'listContent')[1].text;
    String currentPage = RegExp(r'第(\S*)页').allMatches(pageInfo).first.group(1)!;
    String totalPage = RegExp(r'共(\S*)页').allMatches(pageInfo).first.group(1)!;

    return OaExpensePage()
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
