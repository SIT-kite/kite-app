import 'package:kite/entity/library/holding_preview.dart';

abstract class HoldingPreviewDao {
  Future<HoldingPreviews> getHoldingPreviews(List<String> bookIdList);
}
