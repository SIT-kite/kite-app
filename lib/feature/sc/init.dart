import 'package:kite/abstract/abstract_session.dart';

import 'dao/index.dart';
import 'dao/list.dart';
import 'sc_session.dart';
import 'service/index.dart';

class ScInitializer {
  static late ScSession session;
  static late ScActivityListDao scActivityListService;
  static late ScActivityDetailDao scActivityDetailService;
  static late ScJoinActivityDao scJoinActivityService;
  static late ScScoreDao scScoreService;

  static void init({
    required ASession ssoSession,
  }) {
    session = ScSession(ssoSession);
    scActivityListService = ScActivityListService(session);
    scActivityDetailService = ScActivityDetailService(session);
    scJoinActivityService = ScJoinActivityService(session);
    scScoreService = ScScoreService(session);
  }
}
