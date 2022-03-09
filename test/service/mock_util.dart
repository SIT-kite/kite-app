import 'package:kite/domain/library/init.dart';
import 'package:kite/global/dio_initializer.dart';

// 导出一些测试环境下常用的东西
export 'package:flutter_test/flutter_test.dart';
export 'package:kite/global/dio_initializer.dart';
export 'package:kite/util/logger.dart';

// 这里填写用于测试的用户名密码
const String username = '';
const String ssoPassword = '';

// 图书馆密码
const String libraryPassword = '';

// 如果需要代理，请在这里设置
const String proxy = '';

/// 测试前调用该函数做初始化
Future<void> init() async {
  await SessionPool.init();
  if (proxy.isNotEmpty) {
    /// 使用代理
    SessionPool.httpProxy = proxy;
  }
}

/// 如果需要登录，调用该函数
Future<void> login() async {
  await SessionPool.ssoSession.login(username, ssoPassword);
}

/// 图书馆登陆
Future<void> loginLibrary() async {
  await LibraryInitializer.session.login(username, libraryPassword);
}
