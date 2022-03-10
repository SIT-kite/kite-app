import 'package:kite/abstract/abstract_session.dart';

class ConnectivityInitializer {
  static late ASession ssoSession;
  static void init({required ASession ssoSession}) {
    ConnectivityInitializer.ssoSession = ssoSession;
  }
}
