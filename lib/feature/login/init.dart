import 'package:kite/session/sso/index.dart';

import 'service/authserver.dart';

class LoginInitializer {
  static late AuthServerService authServerService;
  static late SsoSession ssoSession;
  static void init({
    required SsoSession ssoSession,
  }) {
    LoginInitializer.ssoSession = ssoSession;
    authServerService = AuthServerService(ssoSession);
  }
}
