import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:kite/app.dart';
import 'package:universal_platform/universal_platform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
    // Android/IOS使用 Bugly
    // 使用说明 https://pub.dev/packages/flutter_bugly
    FlutterBugly.postCatchedException(() async {
      runApp(Phoenix(child: const KiteApp()));
      FlutterBugly.init(
        androidAppId: "a83ed5243d",
        iOSAppId: "7d8c9907b5",
      );
    });
  } else {
    // 桌面端和 Web 端不使用 Bugly
    runApp(Phoenix(child: const KiteApp()));
  }
}
