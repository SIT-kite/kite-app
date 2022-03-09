import 'package:kite/session/sso/sso_session.dart';

import 'dao/bulletin.dart';
import 'service/bulletin.dart';

class BulletinInitializer {
  static late BulletinDao bulletin;
  static late SsoSession session;
  static void init({required SsoSession ssoSession}) {
    BulletinInitializer.session = ssoSession;
    bulletin = BulletinService(session);
  }
}
