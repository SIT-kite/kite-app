import 'package:kite/global/service_pool.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/page_logger.dart';

import 'session_pool.dart';
import 'storage_pool.dart';

/// 应用启动前需要的初始化
Future<void> initBeforeRun() async {
  // Future.wait可以使多个Future并发执行
  Log.info('应用初始化开始');
  // 网络层依赖由存储层提供的缓存，必须先初始化存储层，再初始化网络层
  await StoragePool.init();
  await SessionPool.init();
  ServicePool.init();
  Log.info('应用初始化完成');

  // 初始化用户首次打开时间（而不是应用安装时间）
  // ??= 表示为空时候才赋值
  StoragePool.homeSetting.installTime ??= DateTime.now();

  // 若本地存放了用户名与密码，那就惰性登录
  String? currentUsername = StoragePool.authSetting.currentUsername;
  if (currentUsername != null) {
    // 惰性登录
    String password = StoragePool.authPool.get(currentUsername)!.password;
    SessionPool.ssoSession.lazyLogin(currentUsername, password);
  }
  pageLogger.startup();
}
