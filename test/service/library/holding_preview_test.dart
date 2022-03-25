import 'package:flutter_test/flutter_test.dart';
import 'package:kite/feature/initializer_index.dart';
import 'package:kite/feature/library/search/service/holding_preview.dart';
import 'package:kite/util/logger.dart';

void main() {
  test('test holding previews', () async {
    var a = await HoldingPreviewService(LibraryInitializer.session).getHoldingPreviews([
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
