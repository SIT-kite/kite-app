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
import 'package:kite/domain/bulletin/init.dart';
import 'package:kite/domain/contact/init.dart';
import 'package:kite/domain/edu/init.dart';
import 'package:kite/domain/expense/init.dart';
import 'package:kite/domain/library/init.dart';

import 'session_pool.dart';

/// 网络服务请求池
class ServicePool {
  /// 初始化其他service
  static void _initOther() {}

  static Future<void> init() async {
    await LibraryInitializer.init(SessionPool.librarySession);
    EduInitializer.init(SessionPool.eduSession);
    BulletinInitializer.init(SessionPool.ssoSession);
    await ExpenseInitializer.init(SessionPool.ssoSession);
    await ContactInitializer.init(SessionPool.kiteSession);
    _initOther();
  }
}
