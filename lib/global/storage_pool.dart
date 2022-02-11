/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
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
import 'package:kite/dao/mail.dart';
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
import 'package:kite/storage/mail.dart';
import 'package:kite/storage/network.dart';
import 'package:kite/storage/theme.dart';
import 'package:kite/storage/timetable.dart';
import 'package:kite/storage/user_event.dart';
import 'package:kite/util/hive_cache_provider.dart';
import 'package:kite/util/logger.dart';

import '../dao/game.dart';
import '../entity/game.dart';
import '../storage/auth_pool.dart';
import '../storage/expense.dart';
import '../storage/game.dart';
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

  static ContactStorageDao get contactData => _contactData;

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

  static late TimetableStorage _course;

  static TimetableStorageDao get course => _course;

  static late UserEventStorage _userEvent;

  static UserEventStorageDao get userEvent => _userEvent;

  static late GameStorage _game;

  static GameRecordStorageDao get gameRecord => _game;

  static late MailStorage _mail;

  static MailStorageDao get mail => _mail;

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
    registerAdapter(GameTypeAdapter());
    registerAdapter(GameRecordAdapter());
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

    final courseBox = await Hive.openBox<dynamic>('course');
    _course = TimetableStorage(courseBox);

    final userEventStorage = await Hive.openBox<dynamic>('userEvent');
    _userEvent = UserEventStorage(userEventStorage);

    final gameStorage = await Hive.openBox<dynamic>('game');
    _game = GameStorage(gameStorage);

    final mailStorage = await Hive.openBox<dynamic>('mail');
    _mail = MailStorage(mailStorage);
  }

  static Future<void> clear() async {
    await Hive.close();
    await Hive.deleteBoxFromDisk('setting');
    await Hive.deleteBoxFromDisk('auth');
    await Hive.deleteBoxFromDisk('library.search_history');
    await Hive.deleteBoxFromDisk('course');
    await Hive.deleteBoxFromDisk('expense');
    await Hive.deleteBoxFromDisk('game');
    await Hive.deleteBoxFromDisk('mail');
  }
}
