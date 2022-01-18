import 'package:kite/util/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeStorage {
  static final _namespace = Path().forward('theme');
  static final _colorKey = _namespace.forward('color').toString();

  final SharedPreferences prefs;

  const HomeStorage(this.prefs);

  int get campus => prefs.getInt(_colorKey) ?? 1;

  set campus(int value) => prefs.setInt(_colorKey, value);
}
