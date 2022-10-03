import 'package:flutter_test/flutter_test.dart';
import 'package:kite/module/library/search/init.dart';
import 'package:kite/module/library/search/service/index.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('should', () async {
    var session = LibrarySearchInit.session;
    var s = await HotSearchService(session).getHotSearch();
    logger.i(s.toString());
  });
}
