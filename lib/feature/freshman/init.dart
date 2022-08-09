import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/feature/freshman/freshman_session.dart';
import 'package:kite/feature/freshman/service.dart';
import 'package:kite/setting/init.dart';

import 'dao.dart';

class FreshmanInitializer {
  static late FreshmanSession freshmanSession;
  static late FreshmanDao freshmanDao;
  static Future<void> init({
    required ASession kiteSession,
  }) async {
    freshmanSession = FreshmanSession(kiteSession, SettingInitializer.auth);

    freshmanDao = FreshmanService(freshmanSession);
    // freshmanDao = FreshmanMock();
  }
}
