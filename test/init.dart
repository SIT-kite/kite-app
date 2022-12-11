import 'package:kite/credential/entity/credential.dart';
import 'package:kite/global/global.dart';
import 'package:kite/global/init.dart';
import 'config.dart';
export 'config.dart';
import 'package:kite/module/library/search/init.dart';
import 'package:kite/module/symbol.dart';

// 导出一些测试环境下常用的东西
export 'package:flutter_test/flutter_test.dart';
export 'package:kite/global/dio_initializer.dart';
export 'package:kite/util/logger.dart';

/// 测试前调用该函数做初始化
Future<void> init({bool? debugNetwork}) async {
  GlobalConfig.isTestEnv = true;
  if (httpProxy.isNotEmpty) {
    /// 使用代理
    GlobalConfig.httpProxy = httpProxy;
  }
  await Initializer.init(debugNetwork: debugNetwork);
}

/// 如果需要登录，调用该函数
Future<void> login() async {
  await Global.ssoSession.loginPassive(OACredential(username, ssoPassword));
}

/// 图书馆登录
Future<void> loginLibrary() async {
  await LibrarySearchInit.session.login(username, libraryPassword);
}

/// 登录小风筝服务
Future<void> loginKite() async {
  await SharedInit.kiteSession.login(username, ssoPassword);
}
