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
import 'package:catcher/catcher.dart';
import 'package:kite/feature/board/init.dart';
import 'package:kite/feature/freshman/init.dart';
import 'package:kite/feature/initializer_index.dart';
import 'package:kite/feature/override/init.dart';
import 'package:kite/feature/sit_app/init.dart';
import 'package:kite/global/desktop_initializer.dart';
import 'package:kite/global/global.dart';
import 'package:kite/session/kite_session.dart';
import 'package:kite/session/sit_app_session.dart';
import 'package:kite/setting/init.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/logger.dart';
import 'package:universal_platform/universal_platform.dart';

import '../feature/electricity/init.dart';
import 'hive_initializer.dart';

class Initializer {
  static Future<void> init() async {
    // 运行前初始化
    try {
      await _init();
    } on Exception catch (error, stackTrace) {
      try {
        Catcher.reportCheckedError(error, stackTrace);
      } catch (e) {
        Log.error([error, stackTrace]);
      }
    }
  }

  static Future<void> _init() async {
    // Initialize the window size before others for a better experience when loading.
    if (UniversalPlatform.isDesktop && !GlobalConfig.isTestEnv) {
      await DesktopInitializer.init();
    }

    // 初始化Hive数据库

    await HiveBoxInitializer.init('kite1/hive');
    await UserEventInitializer.init(userEventBox: HiveBoxInitializer.userEvent);
    KvStorageInitializer.init(kvStorageBox: HiveBoxInitializer.kv);
    SettingInitializer.init(kvStorageBox: HiveBoxInitializer.kv);
    await Global.init(
      userEventStorage: UserEventInitializer.userEventStorage,
      authSetting: KvStorageInitializer.auth,
    );
    // 初始化用户首次打开时间（而不是应用安装时间）
    // ??= 表示为空时候才赋值
    KvStorageInitializer.home.installTime ??= DateTime.now();

    BulletinInitializer.init(ssoSession: Global.ssoSession);
    CampusCardInitializer.init(session: Global.ssoSession);
    ConnectivityInitializer.init(ssoSession: Global.ssoSession);

    final kiteSession = KiteSession(
      Global.dio,
      KvStorageInitializer.jwt,
      KvStorageInitializer.kite,
    );
    FunctionOverrideInitializer.init(
      kiteSession: kiteSession,
      storageDao: KvStorageInitializer.override,
    );

    await ContactInitializer.init(
      kiteSession: kiteSession,
      contactDataBox: HiveBoxInitializer.contactSetting,
    );
    await EduInitializer.init(
      ssoSession: Global.ssoSession,
      cookieJar: Global.cookieJar,
      timetableBox: HiveBoxInitializer.course,
    );
    await ExpenseInitializer.init(
      ssoSession: Global.ssoSession2,
      expenseRecordBox: HiveBoxInitializer.expense,
    );

    await KiteInitializer.init(
      kiteSession: kiteSession,
    );
    await GameInitializer.init(
      gameBox: HiveBoxInitializer.game,
      kiteSession: kiteSession,
    );
    await HomeInitializer.init(
      ssoSession: Global.ssoSession,
      noticeService: KiteInitializer.noticeService,
    );
    await LibraryInitializer.init(
      dio: Global.dio,
      searchHistoryBox: HiveBoxInitializer.librarySearchHistory,
      kiteSession: kiteSession,
    );
    await MailInitializer.init();
    await OfficeInitializer.init(
      dio: Global.dio,
      cookieJar: Global.cookieJar,
    );
    ReportInitializer.init(dio: Global.dio);
    ScInitializer.init(ssoSession: Global.ssoSession);
    LoginInitializer.init(ssoSession: Global.ssoSession);

    await FreshmanInitializer.init(kiteSession: kiteSession);

    await ElectricityInitializer.init(
      kiteSession: kiteSession,
      electricityBox: HiveBoxInitializer.kv,
    );

    final sitAppSession = SitAppSession(
      Global.dio,
      KvStorageInitializer.sitAppJwt,
    );
    SitAppInitializer.init(sitAppSession: sitAppSession);
    BoardInitializer.init(kiteSession: kiteSession);
  }
}
