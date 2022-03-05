import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:intl/intl.dart';
import 'package:kite/dao/library/borrow.dart';
import 'package:kite/entity/library/borrow.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

import 'constant.dart';

class LibraryBorrowService extends AService implements LibraryBorrowDao {
  LibraryBorrowService(ASession session) : super(session);

  @override
  Future<List<HistoryBorrowBookItem>> getHistoryBorrowBookList(int page, int rows) async {
    final response = await session.get(
      Constants.historyLoanListUrl,
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
  Future<List<BorrowBookItem>> getMyBorrowBookList(int page, int rows) {
    // TODO: implement getMyBorrowBookList
    throw UnimplementedError();
  }

  @override
  Future<void> renewBook(String barcode) {
    // TODO: implement renewBook
    throw UnimplementedError();
  }
}
