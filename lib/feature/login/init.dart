import 'package:kite/abstract/abstract_session.dart';

import 'service/authserver.dart';

class LoginInitializer {
  static late AuthServerService authServerService;

  static void init({
    required ASession ssoSession,
  }) {
    authServerService = AuthServerService(ssoSession);
  }
}
