import 'package:kite/network/session.dart';

import 'service.dart';

class BoardInitializer {
  static late BoardService boardServiceDao;

  static void init({required Session kiteSession}) {
    boardServiceDao = BoardService(kiteSession);
  }
}
