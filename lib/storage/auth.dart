import 'package:kite/util/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static final _namespace = Path().forward('auth');
  static final _usernameKey = _namespace.forward('username').toString();
  static final _passwordKey = _namespace.forward('password').toString();

  final SharedPreferences prefs;
  const AuthStorage(this.prefs);

  String get username => prefs.getString(_usernameKey) ?? '';
  String get password => prefs.getString(_passwordKey) ?? '';
  set username(String foo) => prefs.setString(_usernameKey, foo);
  set password(String foo) => prefs.setString(_passwordKey, foo);
  bool get hasUsername => prefs.containsKey(_usernameKey);
  bool get hasPassword => prefs.containsKey(_passwordKey);
}
