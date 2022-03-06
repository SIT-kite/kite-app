import 'package:flutter_test/flutter_test.dart';
import 'package:kite/domain/library/service/index.dart';
import 'package:kite/global/session_pool.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('should', () async {
    var session = SessionPool.librarySession;
    var s = await HotSearchService(session).getHotSearch();
    logger.i(s.toString());
  });
}
