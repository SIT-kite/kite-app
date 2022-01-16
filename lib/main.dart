import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:kite/app.dart';

import 'services/session_pool.dart';

void main() async {
  // 使用说明
  // https://pub.dev/packages/flutter_bugly
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      // Android/IOS使用Bugly
      FlutterBugly.postCatchedException(() {
        runApp(Phoenix(child: const KiteApp()));

        SessionPool.initUserAgentString();
        FlutterBugly.init(
          androidAppId: "a83ed5243d",
          iOSAppId: "7d8c9907b5",
        );
      });
    } else {
      // 桌面端不使用 Bugly
      runApp(Phoenix(child: const KiteApp()));
    }
  } on Error catch (_, e) {
    // Web端不支持判定平台，也不使用 Bugly
    runApp(Phoenix(child: const KiteApp()));
  }
}
