import 'package:flutter_test/flutter_test.dart';
import 'package:kite/feature/library/search/init.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('book_info test', () async {
    var books = await LibrarySearchInitializer.bookSearch.search(rows: 100);
    var bookInfo = await LibrarySearchInitializer.bookInfo.query(books.books[0].bookId);
    logger.i(bookInfo);
  });
}
