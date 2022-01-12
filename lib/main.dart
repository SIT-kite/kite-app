import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:kite/app.dart';

void main() async {
  // 使用说明
  // https://pub.dev/packages/flutter_bugly
  FlutterBugly.postCatchedException(() {
    runApp(Phoenix(
      child: const KiteApp(),
    ));

    FlutterBugly.init(
      androidAppId: "a83ed5243d",
      iOSAppId: "7d8c9907b5",
    );
  });
}
