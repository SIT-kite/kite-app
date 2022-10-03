import 'package:kite/network/session.dart';

import 'service/kite_board.dart';

class BoardInit {
  static late BoardService boardServiceDao;

  static Future<void> init({required ISession kiteSession}) async {
    boardServiceDao = BoardService(kiteSession);
  }
}
