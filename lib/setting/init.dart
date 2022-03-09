import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:kite/util/hive_cache_provider.dart';

import 'dao/index.dart';
import 'storage/index.dart';

class SettingInitializer {
  static late ThemeSettingDao theme;
  static late AuthSettingDao auth;
  static late NetworkSettingDao network;
  static late JwtDao jwt;
  static late HomeSettingDao home;

  static Future<void> init() async {
    final settingBox = await Hive.openBox<dynamic>('setting');

    auth = AuthSettingStorage(settingBox);
    home = HomeSettingStorage(settingBox);
    theme = ThemeSettingStorage(settingBox);
    network = NetworkSettingStorage(settingBox);
    jwt = JwtStorage(settingBox);
    Settings.init(cacheProvider: HiveCacheProvider(settingBox));
  }
}
