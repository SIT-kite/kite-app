import 'package:hive_flutter/hive_flutter.dart';

import 'dao/index.dart';
import 'storage/index.dart';

export 'dao/index.dart';
export 'storage/index.dart';

class KvStorageInitializer {
  static late ThemeSettingDao theme;
  static late AuthSettingDao auth;
  static late NetworkSettingDao network;
  static late JwtDao jwt;
  static late JwtDao sitAppJwt;
  static late HomeSettingDao home;
  static late LoginTimeDao loginTime;
  static late FreshmanCacheDao freshman;
  static late Box<dynamic> kvStorageBox;

  static Future<void> init({
    required Box<dynamic> kvStorageBox,
  }) async {
    KvStorageInitializer.kvStorageBox = kvStorageBox;
    auth = AuthSettingStorage(kvStorageBox);
    home = HomeSettingStorage(kvStorageBox);
    theme = ThemeSettingStorage(kvStorageBox);
    network = NetworkSettingStorage(kvStorageBox);
    jwt = JwtStorage(kvStorageBox);
    sitAppJwt = SitAppJwtStorage(kvStorageBox);
    loginTime = LoginTimeStorage(kvStorageBox);
    freshman = FreshmanCacheStorage(kvStorageBox);
  }
}
