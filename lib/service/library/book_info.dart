import 'dart:collection';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/dao/library/book_info.dart';
import 'package:kite/entity/library/book_info.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/service/abstract_session.dart';
import 'package:kite/service/library/constant.dart';

class BookInfoService extends AService implements BookInfoDao {
  BookInfoService(ASession session) : super(session);

  BookInfo _createBookInfo(LinkedHashMap<String, String> rawDetail) {
    final isbnAndPriceStr = rawDetail['ISBN']!;
    final isbnAndPrice = isbnAndPriceStr.split('价格：');
    final isbn = isbnAndPrice[0];
    final price = isbnAndPrice[1];

    return BookInfo()
      ..title = rawDetail.entries.first.value
      ..isbn = isbn
      ..price = price
      ..rawDetail = rawDetail;
  }

  @override
  Future<BookInfo> query(String bookId) async {
    final response = await session.get(Constants.bookUrl + '/$bookId');
    final html = response.data;

    final detailItems = BeautifulSoup(html)
        .find('table', id: 'bookInfoTable')!
        .findAll('tr')
        .map(
          (e) => e
              .findAll('td')
              .map(
                (e) => e.text.replaceAll(RegExp(r'\s*'), ''),
              )
              .toList(),
        )
        .where(
      (element) {
        if (element.isEmpty) {
          return false;
        }
        String e1 = element[0];

        // 过滤包含这些关键字的条目
        for (final keyword in ['分享', '相关', '随书']) {
          if (e1.contains(keyword)) return false;
        }

        return true;
      },
    ).toList();

    final rawDetail = LinkedHashMap.fromEntries(
      detailItems.sublist(1).map(
            (e) => MapEntry(
              e[0].substring(0, e[0].length - 1),
              e[1],
            ),
          ),
    );
    return _createBookInfo(rawDetail);
  }
}
