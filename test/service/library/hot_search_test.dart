import 'package:flutter_test/flutter_test.dart';
import 'package:kite/feature/library/search/init.dart';
import 'package:kite/feature/library/search/service/index.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('should', () async {
    var session = LibrarySearchInitializer.session;
    var s = await HotSearchService(session).getHotSearch();
    logger.i(s.toString());
  });
}
