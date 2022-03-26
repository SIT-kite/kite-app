import 'package:kite/session/sso/index.dart';

class ConnectivityInitializer {
  static late SsoSession ssoSession;
  static void init({required SsoSession ssoSession}) {
    ConnectivityInitializer.ssoSession = ssoSession;
  }
}
