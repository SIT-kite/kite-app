import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/dao/auth_pool.dart';
import 'package:kite/dao/library/search_history.dart';
import 'package:kite/dao/setting/auth.dart';
import 'package:kite/dao/setting/home.dart';
import 'package:kite/entity/auth_item.dart';
import 'package:kite/entity/library/search_history.dart';
import 'package:kite/storage/network.dart';
import 'package:kite/storage/setting/auth.dart';
import 'package:kite/storage/setting/home.dart';
import 'package:kite/util/hive_cache_provider.dart';
import 'package:kite/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_pool.dart';
import 'search_history.dart';

/// 本地持久化层
class StoragePool {
  static late AuthPoolStorage _authPool;
  static AuthPoolDao get authPool => _authPool;

  static late SearchHistoryStorage _librarySearchHistory;
  static SearchHistoryDao get librarySearchHistory => _librarySearchHistory;

  static late HomeSettingStorage _homeSetting;
  static HomeSettingDao get homeSetting => _homeSetting;

  static late AuthSettingDao _authSetting;
  static AuthSettingDao get authSetting => _authSetting;

  static late NetworkStorage _network;

  static NetworkStorage get network => _network;

  static Future<void> init() async {
    Log.info("初始化StoragePool");

    final _prefs = await SharedPreferences.getInstance();
    _network = NetworkStorage(_prefs);

    await Hive.initFlutter();

    Hive.registerAdapter(SearchHistoryItemAdapter());
    Hive.registerAdapter(AuthItemAdapter());

    final searchHistoryBox = await Hive.openBox<SearchHistoryItem>('library.search_history');
    _librarySearchHistory = SearchHistoryStorage(searchHistoryBox);

    final authBox = await Hive.openBox<AuthItem>('auth');
    _authPool = AuthPoolStorage(authBox);

    final settingBox = await Hive.openBox<dynamic>('setting');
    _authSetting = AuthSettingStorage(settingBox);
    _homeSetting = HomeSettingStorage(settingBox);
    Settings.init(cacheProvider: HiveCacheProvider(settingBox));
  }
}
