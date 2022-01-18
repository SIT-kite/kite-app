import 'package:flutter_test/flutter_test.dart';
import 'package:kite/service/library.dart';
import 'package:kite/global/session_pool.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('book_info test', () async {
    var session = SessionPool.librarySession;
    var books = await BookSearchService(session).search(rows: 100);
    var bookInfo = await BookInfoService(session).query(books.books[0].bookId);
    logger.i(bookInfo);
  });
}
