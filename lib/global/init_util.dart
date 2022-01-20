import 'package:kite/util/logger.dart';

import 'session_pool.dart';
import 'storage_pool.dart';

/// 应用启动前需要的初始化
Future<void> initBeforeRun() async {
  // Future.wait可以使多个Future并发执行
  Log.info('开始应用开启前的初始化');
  await Future.wait([
    SessionPool.init(),
    StoragePool.init(),
  ]);
  Log.info('应用开启前初始化完成');
}
