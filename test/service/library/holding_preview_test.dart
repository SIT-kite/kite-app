import 'package:flutter_test/flutter_test.dart';
import 'package:kite/domain/library/service/holding_preview.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/util/logger.dart';

void main() {
  test('test holding previews', () async {
    var a = await HoldingPreviewService(SessionPool.librarySession).getHoldingPreviews([
      326130,
      170523,
      54387,
      170520,
      169833,
      495521,
      393649,
      309076,
      262547,
      465036,
    ].map((e) => e.toString()).toList());
    Log.info(a);
  });
}
