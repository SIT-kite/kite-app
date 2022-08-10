import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/setting/init.dart';

import 'cached_service.dart';
import 'dao.dart';
import 'freshman_session.dart';
import 'service.dart';

class FreshmanInitializer {
  static late FreshmanSession freshmanSession;
  static late FreshmanDao freshmanDao;

  static Future<void> init({
    required ASession kiteSession,
  }) async {
    freshmanSession = FreshmanSession(kiteSession, SettingInitializer.auth);
    freshmanDao = CachedFreshmanService(FreshmanService(freshmanSession), SettingInitializer.freshman);
  }
}
