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
import 'package:kite/credential/init.dart';
import 'package:kite/global/desktop_init.dart';
import 'package:kite/global/global.dart';
import 'package:kite/hive/init.dart';
import 'package:kite/home/init.dart';
import 'package:kite/migration/migrations.dart';
import 'package:kite/module/classroom_browser/init.dart';
import 'package:kite/module/symbol.dart';
import 'package:kite/override/init.dart';
import 'package:kite/session/edu_session.dart';
import 'package:kite/session/kite_session.dart';
import 'package:kite/session/sit_app_session.dart';
import 'package:kite/settings/symbol.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/logger.dart';
import 'package:path/path.dart' as path;
import 'package:universal_platform/universal_platform.dart';

import '../session/dio_common.dart';
import '../util/upgrade.dart';

class Initializer {
  static late AppVersion currentVersion;

  static Future<void> init({bool? debugNetwork}) async {
    // 运行前初始化
    try {
      await _init(debugNetwork: debugNetwork);
    } on Exception catch (error, stackTrace) {
      try {
        Catcher.reportCheckedError(error, stackTrace);
      } catch (e) {
        Log.error([error, stackTrace]);
      }
    }
  }

  static Future<void> _init({bool? debugNetwork}) async {
    // Initialize the window size before others for a better experience when loading.
    if (UniversalPlatform.isDesktop && !GlobalConfig.isTestEnv) {
      await DesktopInit.init();
    }

    // 初始化Hive数据库
    if (UniversalPlatform.isDesktop) {
      await HiveBoxInit.init(path.join("cn.edu.sit.kite", "hive"));
    } else {
      await HiveBoxInit.init(path.join("kite1", "hive"));
    }
    await UserEventInit.init(
      userEventBox: HiveBoxInit.userEvent,
    );
    Kv.init(kvStorageBox: HiveBoxInit.kv);
    currentVersion = await getCurrentVersion();
    await Migrations.perform(from: Kv.version.lastVersion, to: currentVersion.full);
    Kv.version.lastVersion = currentVersion.full;
    Kv.version.lastStartupTime = DateTime.now();
    if (UniversalPlatform.isDesktop) {
      final lastWindowSize = Kv.theme.lastWindowSize;
      if (lastWindowSize != null) {
        DesktopInit.resizeTo(lastWindowSize);
      }
    }
    SettingsInit.init(
      kvStorageBox: HiveBoxInit.kv,
    );
    CredentialInit.init(
      box: HiveBoxInit.credential,
    );
    await Global.init(
      userEventStorage: UserEventInit.userEventStorage,
      authSetting: Kv.auth,
      debugNetwork: debugNetwork ?? Kv.network.isGlobalProxy,
      cookieBox: HiveBoxInit.cookiesBox,
      credentials: CredentialInit.credential,
    );
    // 初始化用户首次打开时间（而不是应用安装时间）
    // ??= 表示为空时候才赋值
    Kv.home.installTime ??= DateTime.now();

    OaAnnounceInit.init(
      ssoSession: Global.ssoSession,
      box: HiveBoxInit.oaAnnounceCache,
    );
    CampusCardInit.init(
      session: Global.ssoSession,
    );
    ConnectivityInit.init(
      ssoSession: Global.ssoSession,
    );

    final kiteSession = KiteSession(
      Global.dio,
      Kv.jwt,
      Kv.kite,
    );
    FunctionOverrideInit.init(
      kiteSession: kiteSession,
      storageDao: Kv.override,
    );

    await YellowPagesInit.init(
      kiteSession: kiteSession,
      contactDataBox: HiveBoxInit.contactSetting,
    );
    await ClassroomBrowserInit.init(
      kiteSession: kiteSession,
    );

    final sharedEduSession = EduSession(
      Global.ssoSession,
    );
    await ExamResultInit.init(
      cookieJar: Global.cookieJar,
      eduSession: sharedEduSession,
    );
    await ExamArrInit.init(
      eduSession: sharedEduSession,
      box: HiveBoxInit.examArrCache,
    );
    await TimetableInit.init(
      eduSession: sharedEduSession,
      kiteSession: kiteSession,
      timetableBox: HiveBoxInit.course,
      ssoSession: Global.ssoSession,
    );

    await ExpenseTrackerInit.init(
      session: Global.ssoSession2,
      expenseBox: HiveBoxInit.expense2,
    );

    await SharedInit.init(
      kiteSession: kiteSession,
    );
    await GameInit.init(
      gameBox: HiveBoxInit.game,
      kiteSession: kiteSession,
    );
    await KiteBulletinInit.init(
      session: DefaultDioSession(Global.dio),
    );
    await BoardInit.init(
      kiteSession: kiteSession,
    );
    await HomeInit.init(
      ssoSession: Global.ssoSession,
    );
    await LibraryInit.init(
      dio: Global.dio,
      searchHistoryBox: HiveBoxInit.librarySearchHistory,
      kiteSession: kiteSession,
    );
    await EduEmailInit.init();
    await ApplicationInit.init(
      dio: Global.dio,
      cookieJar: Global.cookieJar,
      box: HiveBoxInit.applicationCache,
    );
    ReportTempInit.init(dio: Global.dio);
    ScInit.init(
      ssoSession: Global.ssoSession,
      box: HiveBoxInit.activityCache,
    );
    LoginInit.init(
      ssoSession: Global.ssoSession,
    );

    await FreshmanInit.init(
      kiteSession: kiteSession,
    );

    await ElectricityBillInit.init(
      kiteSession: kiteSession,
      electricityBox: HiveBoxInit.kv,
    );

    final sitAppSession = SitAppSession(
      Global.dio,
      Kv.sitAppJwt,
    );
    BoardInit.init(kiteSession: kiteSession);
  }
}
