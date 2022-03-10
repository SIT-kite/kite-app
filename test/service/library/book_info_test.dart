import 'package:flutter_test/flutter_test.dart';
import 'package:kite/feature/initializer_index.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('book_info test', () async {
    var books = await LibraryInitializer.bookSearch.search(rows: 100);
    var bookInfo = await LibraryInitializer.bookInfo.query(books.books[0].bookId);
    logger.i(bookInfo);
  });
}
