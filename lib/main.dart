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
  // 初始化顺序交换会引发未知bug

  // 先初始化本地持久化层
  await StoragePool.init();
  await SessionPool.init();
}

void main() async {
  // 使用说明
  // https://pub.dev/packages/flutter_bugly
  Log.info('当前的系统版本：' + Platform.operatingSystem);
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      // Android/IOS使用 Bugly
      FlutterBugly.postCatchedException(() async {
        runApp(Phoenix(child: const KiteApp()));
        // 初始化持久化池
        await init();
        FlutterBugly.init(
          androidAppId: "a83ed5243d",
          iOSAppId: "7d8c9907b5",
        );
      });
    } else {
      // 桌面端不使用 Bugly
      Log.info('当前环境: Desktop');
      runApp(Phoenix(child: const KiteApp()));
      await init();
    }
  } on Error catch (_, __) {
    // Web端不支持判定平台，也不使用 Bugly
    Log.info('当前环境: Web');
    runApp(Phoenix(child: const KiteApp()));
    await init();
  }
}
