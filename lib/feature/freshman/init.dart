import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/setting/init.dart';

import 'cached_service.dart';
import 'dao.dart';
import 'freshman_session.dart';
import 'service.dart';

class FreshmanInitializer {
  static late FreshmanSession freshmanSession;
  static late FreshmanDao freshmanDao;
  static late FreshmanCacheManager freshmanCacheManager;

  static Future<void> init({
    required ASession kiteSession,
  }) async {
    freshmanSession = FreshmanSession(kiteSession, SettingInitializer.freshman);
    freshmanCacheManager = FreshmanCacheManager(SettingInitializer.freshman);
    freshmanDao = CachedFreshmanService(
      freshmanDao: FreshmanService(freshmanSession),
      freshmanCacheDao: SettingInitializer.freshman,
      freshmanCacheManager: freshmanCacheManager,
    );
  }
}
