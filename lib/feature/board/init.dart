import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/feature/board/dao.dart';

import 'service.dart';

class BoardInitializer {
  static late BoardDao boardServiceDao;

  static void init({required ASession kiteSession}) {
    boardServiceDao = BoardService(kiteSession);
  }
}
