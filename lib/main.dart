import 'package:catcher/catcher.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:kite/app.dart';
import 'package:kite/global/init_util.dart';

const exceptionLogUrl = "https://kite.sunnysab.cn/api/v2/exception";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  CatcherOptions catcherOptions = CatcherOptions(
    // 对话框和新页面的方式不是很好汉化, 且程序中存在连续抛异常的情况, 为不打扰用户直接静默上报
    SilentReportMode(),
    [
      ConsoleHandler(),
      ToastHandler(backgroundColor: Colors.black38, customMessage: "程序好像有点小问题"), // 这里给用户一点提示, 避免出错时用户感到奇怪
      HttpHandler(HttpRequestType.post, Uri.parse(exceptionLogUrl), requestTimeout: 5000, printLogs: true),
    ],
  );

  // 运行前初始化
  await initBeforeRun();

  Catcher(rootWidget: Phoenix(child: const KiteApp()), debugConfig: catcherOptions, releaseConfig: catcherOptions);
}
