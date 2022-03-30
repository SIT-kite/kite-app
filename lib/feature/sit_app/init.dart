import 'package:kite/feature/sit_app/arrive_code/service.dart';
import 'package:kite/session/sit_app_session.dart';

import 'arrive_code/dao.dart';

class SitAppInitializer {
  static late SitAppSession sitAppSession;
  static late ArriveCodeDao arriveCodeService;
  static void init({
    required SitAppSession sitAppSession,
  }) {
    SitAppInitializer.sitAppSession = sitAppSession;
    arriveCodeService = ArriveCodeService(sitAppSession);
  }
}
