import 'package:kite/dao/library/holding_preview.dart';
import 'package:kite/entity/library/holding_preview.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

import 'constant.dart';

class HoldingPreviewService extends AService implements HoldingPreviewDao {
  HoldingPreviewService(ASession session) : super(session);

  @override
  Future<HoldingPreviews> getHoldingPreviews(List<String> bookIdList) async {
    var response = await session.get(
      Constants.bookHoldingPreviewsUrl,
      queryParameters: {
        'bookrecnos': bookIdList.join(","),
        'curLibcodes': '',
        'return_fmt': 'json',
      },
    );

    return HoldingPreviews.fromJson(response.data);
  }
}
