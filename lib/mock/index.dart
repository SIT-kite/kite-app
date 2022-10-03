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

import 'package:kite/module/meta.dart';
import 'package:kite/module/library/search/init.dart';
import 'package:kite/global/global.dart';
import 'package:kite/global/init.dart';

import 'config.dart';

// 导出一些测试环境下常用的东西
export 'package:flutter_test/flutter_test.dart';
export 'package:kite/global/dio_initializer.dart';
export 'package:kite/util/logger.dart';

export 'config.dart';

/// 测试前调用该函数做初始化
Future<void> init() async {
  GlobalConfig.isTestEnv = true;
  if (httpProxy.isNotEmpty) {
    /// 使用代理
    GlobalConfig.httpProxy = httpProxy;
  }
  await Initializer.init();
}

/// 如果需要登录，调用该函数
Future<void> login() async {
  await Global.ssoSession.login(username, ssoPassword);
}

/// 图书馆登陆
Future<void> loginLibrary() async {
  await LibrarySearchInitializer.session.login(username, libraryPassword);
}

/// 登陆小风筝服务
Future<void> loginKite() async {
  await KiteInitializer.kiteSession.login(username, ssoPassword);
}

/// 登录上应大App服务
Future<void> loginSitApp() async {
  await SitAppInitializer.sitAppSession.login(username, ssoPassword);
}
