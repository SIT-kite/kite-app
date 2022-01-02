import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/library.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('search test', () async {
    var books = await BookSearchResult.search(keyword: 'Java');
    var result = await BookImage.searchByBookList(books.books);
    logger.d(result);
  });
}
