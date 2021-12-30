import 'package:cookie_jar/cookie_jar.dart';
import 'package:kite/services/sso/sso.dart';

class Constants {
  final session = Session(jar: PersistCookieJar());
  static final Constants _constants = Constants.internal();
  factory Constants() => _constants;
  Constants.internal();
}
