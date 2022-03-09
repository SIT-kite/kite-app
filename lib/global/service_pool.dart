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
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/domain/initializer_index.dart';
import 'package:kite/util/logger.dart';

import 'session_pool.dart';

class Initializer {
  static Future<void> init() async {
    Log.info("初始化StoragePool");
    await Hive.initFlutter('kite/hive');
    await LibraryInitializer.init(SessionPool.librarySession);
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
