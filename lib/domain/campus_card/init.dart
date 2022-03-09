import 'package:kite/abstract/abstract_session.dart';

import 'dao/campus_card.dart';
import 'service/campus_card.dart';

class CampusCardInitializer {
  static late CampusCardDao campusCardService;
  static void init(ASession session) {
    campusCardService = CampusCardService(session);
  }
}
