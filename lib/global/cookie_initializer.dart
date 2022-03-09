import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class CookieInitializer {
  static Future<CookieJar> init() async {
    final String homeDirectory = (await getApplicationDocumentsDirectory()).path;
    final FileStorage cookieStorage = FileStorage(homeDirectory + '/kite/cookies/');
    // 初始化持久化的 cookieJar
    final cookieJar = PersistCookieJar(storage: cookieStorage);
    return cookieJar;
  }
}
