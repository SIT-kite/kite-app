import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/book_search.dart';
import 'package:kite/services/library/library_session.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  var session = LibrarySession();
  test('search test', () async {
    var result = await BookSearchService(session).search(
      keyword: 'Java',
      rows: 10,
    );
    logger.i(result);
  });
}
