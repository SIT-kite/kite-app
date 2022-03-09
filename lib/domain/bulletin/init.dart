import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/session/sso/index.dart';

import 'dao/bulletin.dart';
import 'service/bulletin.dart';

class BulletinInitializer {
  static late BulletinDao bulletin;
  static late SsoSession session;
  static init({required ASession ssoSession}) {
    BulletinInitializer.session = session;
    bulletin = BulletinService(session);
  }
}
