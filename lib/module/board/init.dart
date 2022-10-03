import 'package:kite/network/session.dart';

import 'service.dart';

class BoardInitializer {
  static late BoardService boardServiceDao;

  static void init({required ISession kiteSession}) {
    boardServiceDao = BoardService(kiteSession);
  }
}
