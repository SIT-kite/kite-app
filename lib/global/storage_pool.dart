import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/dao/auth_pool.dart';
import 'package:kite/dao/contact.dart';
import 'package:kite/dao/edu/timetable.dart';
import 'package:kite/dao/electricity.dart';
import 'package:kite/dao/expense.dart';
import 'package:kite/dao/kite/jwt.dart';
import 'package:kite/dao/kite/user_event.dart';
import 'package:kite/dao/library/search_history.dart';
import 'package:kite/dao/setting/auth.dart';
import 'package:kite/dao/setting/home.dart';
import 'package:kite/dao/setting/theme.dart';
import 'package:kite/entity/auth_item.dart';
import 'package:kite/entity/contact.dart';
import 'package:kite/entity/edu/timetable.dart';
import 'package:kite/entity/electricity.dart';
import 'package:kite/entity/expense.dart';
import 'package:kite/entity/kite/user_event.dart';
import 'package:kite/entity/library/search_history.dart';
import 'package:kite/entity/report.dart';
import 'package:kite/entity/weather.dart';
import 'package:kite/storage/auth.dart';
import 'package:kite/storage/contact.dart';
import 'package:kite/storage/electricity.dart';
import 'package:kite/storage/home.dart';
import 'package:kite/storage/jwt.dart';
import 'package:kite/storage/network.dart';
import 'package:kite/storage/theme.dart';
import 'package:kite/storage/timetable.dart';
import 'package:kite/storage/user_event.dart';
import 'package:kite/util/hive_cache_provider.dart';
import 'package:kite/util/logger.dart';

import '../storage/auth_pool.dart';
import '../storage/expense.dart';
import '../storage/library/search_history.dart';

/// 本地持久化层
class StoragePool {
  static late AuthPoolStorage _authPool;

  static AuthPoolDao get authPool => _authPool;

  static late SearchHistoryStorage _librarySearchHistory;

  static SearchHistoryDao get librarySearchHistory => _librarySearchHistory;

  static late ElectricityStorage _electricity;

  static ElectricityStorageDao get electricity => _electricity;

  static late ContactDataStorage _contactData;

  static ContactDataStorageDao get contactData => _contactData;

  static late ExpenseLocalStorage _expenseRecord;

  static ExpenseLocalDao get expenseRecordStorage => _expenseRecord;

  static late HomeSettingStorage _homeSetting;

  static HomeSettingDao get homeSetting => _homeSetting;

  static late ThemeSettingStorage _themeSetting;

  static ThemeSettingDao get themeSetting => _themeSetting;

  static late AuthSettingDao _authSetting;

  static AuthSettingDao get authSetting => _authSetting;

  static late NetworkSettingStorage _networkSetting;

  static NetworkSettingStorage get network => _networkSetting;

  static late TimetableStorageDao _course;

  static TimetableStorageDao get course => _course;

  static late UserEventStorage _userEvent;

  static UserEventStorageDao get userEvent => _userEvent;

  static late JwtDao _jwt;

  static JwtDao get jwt => _jwt;

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
    registerAdapter(CourseAdapter());
    registerAdapter(ExpenseRecordAdapter());
    registerAdapter(ExpenseTypeAdapter());
    registerAdapter(ContactDataAdapter());
    registerAdapter(UserEventAdapter());
    registerAdapter(UserEventTypeAdapter());
  }

  static Future<void> init() async {
    Log.info("初始化StoragePool");

    await Hive.initFlutter();
    await _registerAdapters();
    final expenseRecordBox = await Hive.openBox<ExpenseRecord>('expenseSetting');
    _expenseRecord = ExpenseLocalStorage(expenseRecordBox);
    final searchHistoryBox = await Hive.openBox<LibrarySearchHistoryItem>('library.search_history');
    _librarySearchHistory = SearchHistoryStorage(searchHistoryBox);
    final electricityBox = await Hive.openBox('electricity');
    _electricity = ElectricityStorage(electricityBox);
    final contactDataBox = await Hive.openBox<ContactData>('contactSetting');
    _contactData = ContactDataStorage(contactDataBox);
    final authBox = await Hive.openBox<AuthItem>('auth');
    _authPool = AuthPoolStorage(authBox);

    final settingBox = await Hive.openBox<dynamic>('setting');
    _authSetting = AuthSettingStorage(settingBox);
    _homeSetting = HomeSettingStorage(settingBox);
    _themeSetting = ThemeSettingStorage(settingBox);
    _networkSetting = NetworkSettingStorage(settingBox);
    _jwt = JwtStorage(settingBox);
    Settings.init(cacheProvider: HiveCacheProvider(settingBox));

    final courseBox = await Hive.openBox<Course>('course');
    _course = CourseStorage(courseBox);

    final userEventStorage = await Hive.openBox<dynamic>('userEvent');
    _userEvent = UserEventStorage(userEventStorage);
  }

  static Future<void> clear() async {
    await Hive.close();
    await Hive.deleteBoxFromDisk('setting');
    await Hive.deleteBoxFromDisk('auth');
    await Hive.deleteBoxFromDisk('library.search_history');
    await Hive.deleteBoxFromDisk('course');
    await Hive.deleteBoxFromDisk('expense');
  }
}
