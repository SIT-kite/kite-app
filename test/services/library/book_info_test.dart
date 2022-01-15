import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/book_info.dart';
import 'package:kite/services/library/book_search.dart';
import 'package:kite/services/library/library_session.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('book_info test', () async {
    var session = LibrarySession();
    var books = await BookSearchService(session).search(rows: 100);
    var bookInfo = await BookInfoService(session).query(books.books[0].bookId);
    logger.i(bookInfo);
  });
}
