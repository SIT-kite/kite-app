import 'package:flutter_test/flutter_test.dart';
import 'package:kite/domain/library/service/index.dart';
import 'package:kite/global/session_pool.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  var session = SessionPool.librarySession;
  test('holding test', () async {
    var a = await HoldingInfoService(session).queryByBookId('54387');
    logger.i(a.holdingList);
  });

  test('near book search', () async {
    var list = await HoldingInfoService(session).searchNearBookIdList('54387');
    logger.i(list);
  });
}
