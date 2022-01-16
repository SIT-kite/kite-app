import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/book_search.dart';
import 'package:kite/services/library/image_search.dart';
import 'package:kite/services/session_pool.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  var session = SessionPool.librarySession;
  test('search test', () async {
    var books = await BookSearchService(session).search(keyword: 'Java');
    var result = await BookImageSearchService(session).searchByBookList(books.books);
    logger.d(result);
  });
}
