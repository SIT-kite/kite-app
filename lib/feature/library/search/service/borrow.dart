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
import 'package:intl/intl.dart';
import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';

import '../dao/borrow.dart';
import '../entity/borrow.dart';
import 'constant.dart';

class LibraryBorrowService extends AService implements LibraryBorrowDao {
  LibraryBorrowService(ISession session) : super(session);

  @override
  Future<List<HistoryBorrowBookItem>> getHistoryBorrowBookList(int page, int rows) async {
    final response = await session.request(
      Constants.historyLoanListUrl,
      RequestMethod.get,
      queryParameters: {
        'page': page.toString(),
        'rows': rows.toString(),
      },
    );
    final String html = response.data;
    final table = BeautifulSoup(html).find('table', id: 'contentTable')!;
    return table.findAll('tr').where((e) => e.id != 'contentHeader').map((e) {
      final columns = e.findAll('td');
      final columnsText = columns.map((e) => e.text.trim()).toList();
      return HistoryBorrowBookItem()
        ..bookId = columns[0].find('input')!.attributes['value']!
        ..operateType = columnsText[0]
        ..barcode = columnsText[1]
        ..title = columnsText[2]
        ..isbn = columnsText[3]
        ..author = columnsText[4]
        ..callNo = columnsText[5]
        ..location = columnsText[6]
        ..type = columnsText[7]
        ..processDate = DateFormat('yyyy-MM-dd').parse(columnsText[8]);
    }).toList();
  }

  @override
  Future<List<BorrowBookItem>> getMyBorrowBookList(int page, int rows) async {
    final response = await session.request(
      Constants.currentLoanListUrl,
      RequestMethod.get,
      queryParameters: {
        'page': page.toString(),
        'rows': rows.toString(),
      },
    );
    final String html = response.data;
    final table = BeautifulSoup(html).find('table', id: 'contentTable')!;
    return table.findAll('tr').where((e) => e.id != 'contentHeader').map((e) {
      final columns = e.findAll('td');
      final columnsText = columns.map((e) => e.text.trim()).toList();
      final dataFormat = DateFormat('yyyy-MM-dd');
      return BorrowBookItem()
        ..bookId = columns[0].find('input')!.attributes['value']!
        ..barcode = columnsText[0]
        ..title = columnsText[1]
        ..isbn = columnsText[2]
        ..author = columnsText[3]
        ..callNo = columnsText[4]
        ..location = columnsText[5]
        ..type = columnsText[6]
        ..borrowDate = dataFormat.parse(columnsText[7])
        ..expireDate = dataFormat.parse(columnsText[8]);
    }).toList();
  }

  Future<String> _doRenew({
    required String pdsToken,
    required List<String> barcodeList,
    bool renewAll = false,
  }) async {
    final response = await session.request(
      Constants.doRenewUrl,
      RequestMethod.post,
      data: {
        'pdsToken': pdsToken,
        'barcodeList': barcodeList.join(','),
        'furl': '/opac/loan/renewList',
        'renewAll': renewAll ? 'all' : '',
      },
    );
    return BeautifulSoup(response.data).find('div', id: 'content')!.text;
  }

  @override
  Future<String> renewBook({
    required List<String> barcodeList,
    bool renewAll = false,
  }) async {
    final response = await session.request(Constants.renewList, RequestMethod.get);
    final pdsToken = BeautifulSoup(response.data).find('input', attrs: {'name': 'pdsToken'})!.attributes['value'] ?? '';
    return await _doRenew(
      pdsToken: pdsToken,
      barcodeList: barcodeList,
      renewAll: renewAll,
    );
  }
}
