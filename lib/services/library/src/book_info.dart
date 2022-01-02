import 'dart:collection';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:kite/services/library/src/constants.dart';

class BookInfo {
  final String title;
  final String isbn;
  final String price;
  final LinkedHashMap<String, String> rawDetail;

  const BookInfo(this.title, this.isbn, this.price, this.rawDetail);

  @override
  String toString() {
    return 'BookInfo{title: $title, isbn: $isbn, price: $price, rawDetail: $rawDetail}';
  }

  static Future<BookInfo> query(
    String bookId, {
    Dio? dio,
  }) async {
    var response = await (dio ?? Dio()).get(Constants.bookUrl + '/$bookId');
    var html = response.data;

    var detailItems = BeautifulSoup(html)
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

        for (var keyword in ['分享', '相关', '随书']) {
          if (e1.contains(keyword)) return false;
        }

        return true;
      },
    ).toList();

    var rawDetail = LinkedHashMap.fromEntries(
      detailItems.sublist(1).map(
            (e) => MapEntry(
              e[0].substring(0, e[0].length - 1),
              e[1],
            ),
          ),
    );
    var title = detailItems[0][0];
    var isbnAndPriceStr = rawDetail['ISBN'];
    var isbnAndPrice = isbnAndPriceStr!.split('价格：');
    var isbn = isbnAndPrice[0];
    var price = isbnAndPrice[1];
    return BookInfo(title, isbn, price, rawDetail);
  }
}
