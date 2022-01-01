import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _namespace = '/auth/';
  static const _usernameKey = _namespace + 'username';
  static const _passwordKey = _namespace + 'password';

  final SharedPreferences prefs;
  const AuthStorage(this.prefs);

  String get username => prefs.getString(_usernameKey) ?? '';
  String get password => prefs.getString(_passwordKey) ?? '';
  set username(String foo) => prefs.setString(_usernameKey, foo);
  set password(String foo) => prefs.setString(_passwordKey, foo);
  bool get hasUsername => prefs.containsKey(_usernameKey);
  bool get hasPassword => prefs.containsKey(_passwordKey);
}
