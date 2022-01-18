import 'package:kite/util/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeStorage {
  static final _namespace = Path().forward('home');
  static final _campusKey = _namespace.forward('campus').toString();
  static final _backgroundKey = _namespace.forward('background').toString();
  static final _backgroundModeKey = _namespace.forward('backgroundMode').toString();

  final SharedPreferences prefs;

  const HomeStorage(this.prefs);

  int get campus => prefs.getInt(_campusKey) ?? 1; // Default campus: FENG XIAN
  set campus(int value) => prefs.setInt(_campusKey, value);

  String get background => prefs.getString(_backgroundKey) ?? '';

  set background(String path) => prefs.setString(_backgroundKey, path);

  String get backgroundMode => prefs.getString(_backgroundModeKey) ?? 'weather';

  set backgroundMode(String mode) => prefs.setString(_backgroundModeKey, mode);
}
