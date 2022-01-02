import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/library.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('book_info test', () async {
    var books = await BookSearchResult.search(rows: 100);
    var bookInfo = await BookInfo.query(books.books[0].bookId);
    logger.i(bookInfo);
  });
}
