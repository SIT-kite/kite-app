import 'package:flutter_test/flutter_test.dart';
import 'package:kite/service/library/hot_search.dart';
import 'package:kite/service/session_pool.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('should', () async {
    var session = SessionPool.librarySession;
    var s = await HotSearchService(session).getHotSearch();
    logger.i(s.toString());
  });
}
