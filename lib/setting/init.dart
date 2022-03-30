import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:kite/setting/dao/login.dart';
import 'package:kite/setting/storage/login.dart';
import 'package:kite/util/hive_cache_provider.dart';

import 'dao/index.dart';
import 'storage/index.dart';

class SettingInitializer {
  static late ThemeSettingDao theme;
  static late AuthSettingDao auth;
  static late NetworkSettingDao network;
  static late JwtDao jwt;
  static late JwtDao sitAppJwt;
  static late HomeSettingDao home;
  static late LoginTimeDao loginTime;

  static Future<void> init({
    required Box<dynamic> settingBox,
  }) async {
    auth = AuthSettingStorage(settingBox);
    home = HomeSettingStorage(settingBox);
    theme = ThemeSettingStorage(settingBox);
    network = NetworkSettingStorage(settingBox);
    jwt = JwtStorage(settingBox);
    sitAppJwt = SitAppJwtStorage(settingBox);
    loginTime = LoginTimeStorage(settingBox);
    Settings.init(cacheProvider: HiveCacheProvider(settingBox));
  }
}
