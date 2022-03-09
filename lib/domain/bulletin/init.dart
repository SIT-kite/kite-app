import 'package:kite/abstract/abstract_session.dart';

import 'dao/bulletin.dart';
import 'service/bulletin.dart';

class BulletinInitializer {
  static late BulletinDao bulletin;
  static init(ASession session) {
    bulletin = BulletinService(session);
  }
}
