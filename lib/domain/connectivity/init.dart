import 'package:kite/abstract/abstract_session.dart';

class ConnectivityInitializer {
  static late ASession ssoSession;
  static void init(ASession _ssoSession) {
    ssoSession = _ssoSession;
  }
}
