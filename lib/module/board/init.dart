import 'package:kite/network/session.dart';

import 'service/kite_board.dart';

class BoardInitializer {
  static late BoardService boardServiceDao;

  static void init({required ISession kiteSession}) {
    boardServiceDao = BoardService(kiteSession);
  }
}
