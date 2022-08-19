import 'package:kite/abstract/abstract_session.dart';

import 'service.dart';

class BoardInitializer {
  static late BoardService boardServiceDao;

  static void init({required ASession kiteSession}) {
    boardServiceDao = BoardService(kiteSession);
  }
}
