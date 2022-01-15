import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/hot_search.dart';
import 'package:kite/services/library/library_session.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('should', () async {
    var session = LibrarySession();
    var s = await HotSearchService(session).getHotSearch();
    logger.i(s.toString());
  });
}
