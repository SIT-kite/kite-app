import 'package:kite/feature/initializer_index.dart';
import 'package:kite/feature/library/search/init.dart';
import 'package:kite/feature/sit_app/init.dart';
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
