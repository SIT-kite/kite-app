import 'package:kite/services/edu/src/edu_session.dart';
import 'package:kite/services/sso/sso.dart';

class SessionPool {
  static final Session ssoSession = Session();
  static final EduSession eduSession = EduSession(ssoSession);
}
