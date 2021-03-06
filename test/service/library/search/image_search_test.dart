import 'package:flutter_test/flutter_test.dart';
import 'package:kite/feature/library/search/init.dart';
import 'package:kite/feature/library/search/service/index.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  var session = LibrarySearchInitializer.session;
  test('search test', () async {
    var books = await BookSearchService(session).search(keyword: 'Java');
    var result = await BookImageSearchService(session).searchByIsbnList(books.books.map((e) => e.isbn).toList());
    logger.d(result);
  });
}
