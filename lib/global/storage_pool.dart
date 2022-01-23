import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/dao/auth_pool.dart';
import 'package:kite/dao/electricity.dart';
import 'package:kite/dao/library/search_history.dart';
import 'package:kite/dao/setting/auth.dart';
import 'package:kite/dao/setting/home.dart';
import 'package:kite/dao/setting/theme.dart';
import 'package:kite/entity/auth_item.dart';
import 'package:kite/entity/electricity.dart';
import 'package:kite/entity/library/search_history.dart';
import 'package:kite/entity/report.dart';
import 'package:kite/entity/weather.dart';
import 'package:kite/storage/electricity.dart';
import 'package:kite/storage/setting/auth.dart';
import 'package:kite/storage/setting/home.dart';
import 'package:kite/storage/setting/network.dart';
import 'package:kite/storage/setting/theme.dart';
import 'package:kite/util/hive_cache_provider.dart';
import 'package:kite/util/logger.dart';

import '../storage/auth_pool.dart';
import '../storage/library/search_history.dart';

/// 本地持久化层
class StoragePool {
  static late AuthPoolStorage _authPool;

  static AuthPoolDao get authPool => _authPool;

  static late SearchHistoryStorage _librarySearchHistory;

  static SearchHistoryDao get librarySearchHistory => _librarySearchHistory;

  static late ElectricityStorage _electricity;

  static ElectricityStorageDao get electricity => _electricity;

  static late HomeSettingStorage _homeSetting;

  static HomeSettingDao get homeSetting => _homeSetting;

  static late ThemeSettingStorage _themeSetting;

  static ThemeSettingDao get themeSetting => _themeSetting;

  static late AuthSettingDao _authSetting;

  static AuthSettingDao get authSetting => _authSetting;

  static late NetworkSettingStorage _networkSetting;

  static NetworkSettingStorage get network => _networkSetting;

  static Future<void> _registerAdapters() async {
    void registerAdapter<T>(TypeAdapter<T> adapter) {
      if (!Hive.isAdapterRegistered(adapter.typeId)) {
        Hive.registerAdapter(adapter);
      }
    }

    registerAdapter(LibrarySearchHistoryItemAdapter());
    registerAdapter(AuthItemAdapter());
    registerAdapter(WeatherAdapter());
    registerAdapter(ReportHistoryAdapter());
    registerAdapter(BalanceAdapter());
  }

  static Future<void> init() async {
    Log.info("初始化StoragePool");

    await Hive.initFlutter();
    await _registerAdapters();

    final searchHistoryBox = await Hive.openBox<LibrarySearchHistoryItem>('library.search_history');
    _librarySearchHistory = SearchHistoryStorage(searchHistoryBox);
    final electricityBox = await Hive.openBox('electricity');
    _electricity = ElectricityStorage(electricityBox);

    final authBox = await Hive.openBox<AuthItem>('auth');
    _authPool = AuthPoolStorage(authBox);

    final settingBox = await Hive.openBox<dynamic>('setting');
    _authSetting = AuthSettingStorage(settingBox);
    _homeSetting = HomeSettingStorage(settingBox);
    _themeSetting = ThemeSettingStorage(settingBox);
    _networkSetting = NetworkSettingStorage(settingBox);
    Settings.init(cacheProvider: HiveCacheProvider(settingBox));
  }

  static Future<void> clear() async {
    await Hive.close();

    await Hive.deleteBoxFromDisk('setting');
    await Hive.deleteBoxFromDisk('auth');
    await Hive.deleteBoxFromDisk('library.search_history');
  }
}
