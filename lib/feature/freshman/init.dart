import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/feature/freshman/service.dart';

import 'dao.dart';

class FreshmanInitializer {
  static late FreshmanDao freshmanDao;
  static Future<void> init({
    required ASession kiteSession,
  }) async {
    freshmanDao = FreshmanService(kiteSession);
    // freshmanDao = FreshmanMock();
  }
}
