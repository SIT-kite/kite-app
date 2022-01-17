import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:kite/app.dart';
import 'package:kite/storage/storage_pool.dart';
import 'package:kite/util/logger.dart';

import 'service/session_pool.dart';

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
  // 使用说明
  // https://pub.dev/packages/flutter_bugly
  Log.info('当前操作系统：' + Platform.operatingSystem);
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      // Android/IOS使用 Bugly
      FlutterBugly.postCatchedException(() async {
        Log.info('当前环境: Android/IOS');
        await init();
        runApp(Phoenix(child: const KiteApp()));
        FlutterBugly.init(
          androidAppId: "a83ed5243d",
          iOSAppId: "7d8c9907b5",
        );
      });
    } else {
      // 桌面端不使用 Bugly
      Log.info('当前环境: Desktop');
      await init();
      runApp(Phoenix(child: const KiteApp()));
    }
  } on Error catch (_, __) {
    // Web端不支持判定平台，也不使用 Bugly
    Log.info('当前环境: Web');
    await init();
    runApp(Phoenix(child: const KiteApp()));
  }
}
