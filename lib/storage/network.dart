import 'package:kite/util/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkStorage {
  static final _namespace = Path().forward('network');
  static final _proxyKey = _namespace.forward('proxy').toString();
  static final _useProxyKey = _namespace.forward('useProxy').toString();

  final SharedPreferences prefs;

  const NetworkStorage(this.prefs);

  String get proxy => prefs.getString(_proxyKey) ?? '';

  bool get useProxy => prefs.getBool(_useProxyKey) ?? false;

  set proxy(String foo) => prefs.setString(_proxyKey, foo);

  set useProxy(bool foo) => prefs.setBool(_useProxyKey, foo);
}
