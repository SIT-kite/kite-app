import 'package:kite/session/abstract_session.dart';

import 'dao/bulletin.dart';
import 'service/bulletin.dart';

class BulletinInitializer {
  static late BulletinDao bulletin;
  static init(ASession session) {
    bulletin = BulletinService(session);
  }
}
