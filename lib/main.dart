import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:kite/app.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/util/logger.dart';
import 'package:universal_platform/universal_platform.dart';

import 'global/session_pool.dart';

/// 应用启动前需要的初始化
Future<void> init() async {
  // Future.wait可以使多个Future并发执行
  Log.info('开始应用开启前的初始化');
  await Future.wait([
    SessionPool.init(),
    StoragePool.init(),
  ]);
  Log.info('应用开启前初始化完成');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
    // Android/IOS使用 Bugly
    // 使用说明 https://pub.dev/packages/flutter_bugly
    FlutterBugly.postCatchedException(() async {
      await init();
      runApp(Phoenix(child: const KiteApp()));
      FlutterBugly.init(
        androidAppId: "a83ed5243d",
        iOSAppId: "7d8c9907b5",
      );
    });
  } else {
    // 桌面端和 Web 端不使用 Bugly
    await init();
    runApp(Phoenix(child: const KiteApp()));
  }
}
