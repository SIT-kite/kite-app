import 'package:cookie_jar/cookie_jar.dart';

class Constants {
  final cookieJar = PersistCookieJar();
  static final Constants _constants = Constants.internal();
  factory Constants() => _constants;
  Constants.internal();
}
