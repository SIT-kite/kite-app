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
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/domain/bulletin/init.dart';
import 'package:kite/domain/campus_card/init.dart';
import 'package:kite/domain/connectivity/init.dart';
import 'package:kite/domain/contact/init.dart';
import 'package:kite/domain/edu/init.dart';
import 'package:kite/domain/expense/init.dart';
import 'package:kite/domain/game/init.dart';
import 'package:kite/domain/home/init.dart';
import 'package:kite/domain/initializer_index.dart';
import 'package:kite/domain/kite/init.dart';
import 'package:kite/domain/kite/kite_session.dart';
import 'package:kite/domain/mail/init.dart';
import 'package:kite/domain/office/init.dart';
import 'package:kite/global/global.dart';
import 'package:kite/setting/init.dart';

class Initializer {
  static Future<void> init() async {
    // 初始化Hive数据库
    await Hive.initFlutter('kite/hive');
    await Global.init();
    final ssoSession = Global.ssoSession;
    BulletinInitializer.init(ssoSession: ssoSession);
    CampusCardInitializer.init(session: ssoSession);
    ConnectivityInitializer.init(ssoSession: ssoSession);
    await SettingInitializer.init(ssoSession: ssoSession);

    final kiteSession = KiteSession(Global.dio, SettingInitializer.jwt);
    await ContactInitializer.init(kiteSession: kiteSession);
    await EduInitializer.init(ssoSession: ssoSession, cookieJar: Global.cookieJar);
    await ExpenseInitializer.init(ssoSession: ssoSession);
    await GameInitializer.init();
    await KiteInitializer.init(dio: Global.dio, kiteSession: kiteSession);
    await HomeInitializer.init(ssoSession: ssoSession, noticeService: KiteInitializer.noticeService);
    await LibraryInitializer.init(dio: Global.dio);
    await MailInitializer.init();
    await OfficeInitializer.init(dio: Global.dio, cookieJar: Global.cookieJar);
    ReportInitializer.init(dio: Global.dio);
    ScInitializer.init(ssoSession: ssoSession);
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
