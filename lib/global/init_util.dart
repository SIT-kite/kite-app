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
import 'package:kite/setting/init.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/page_logger.dart';

import 'dio_initializer.dart';

class Initializer {
  static Future<void> init() async {
    Log.info("初始化StoragePool");
    await Hive.initFlutter('kite/hive');
    await LibraryInitializer.init();
    EduInitializer.init(SessionPool.eduSession);
    BulletinInitializer.init(SessionPool.ssoSession);
    await ExpenseInitializer.init(SessionPool.ssoSession);
    await ContactInitializer.init(SessionPool.kiteSession);
    CampusCardInitializer.init(SessionPool.ssoSession);
    ReportInitializer.init();
    ScInitializer.init();
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

/// 应用启动前需要的初始化
Future<void> initBeforeRun() async {
  // Future.wait可以使多个Future并发执行
  Log.info('应用初始化开始');
  // 网络层依赖由存储层提供的缓存，必须先初始化存储层，再初始化网络层
  await SessionPool.init();
  Log.info('应用初始化完成');

  // 初始化用户首次打开时间（而不是应用安装时间）
  // ??= 表示为空时候才赋值
  SettingInitializer.home.installTime ??= DateTime.now();

  // 若本地存放了用户名与密码，那就惰性登录
  final auth = SettingInitializer.auth;
  if (auth.currentUsername != null && auth.ssoPassword != null) {
    // 惰性登录
    SessionPool.ssoSession.lazyLogin(auth.currentUsername!, auth.ssoPassword!);
  }
  pageLogger.startup();
}
