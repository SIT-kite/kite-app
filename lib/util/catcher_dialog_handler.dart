import 'package:catcher/catcher.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/launch.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:stack_trace/stack_trace.dart';

import 'logger.dart';

class DialogHandler extends ReportHandler {
  @override
  String toString() {
    return 'DialogHandler';
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.web,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];

  @override
  Future<bool> handle(Report error, BuildContext? context) async {
    if (context == null) return true;
    if (Kv.developOptions.showErrorInfoDialog == null) return true;
    if (!Kv.developOptions.showErrorInfoDialog!) return true;

    Trace trace = Trace.from(error.stackTrace);
    var frameList = trace.frames.where((e) => e.uri.path.startsWith('kite')).toList();
    var errorMsg = error.error.toString();
    if (frameList.isEmpty && errorMsg.contains('Source stack:')) {
      final msgAndSt = errorMsg.split('Source stack:');
      Log.info(msgAndSt);
      errorMsg = msgAndSt[0];
      frameList = Trace.parse(msgAndSt[1]).frames.where((e) => e.uri.path.startsWith('kite')).toList();
    }

    showAlertDialog(context, title: '程序异常信息', content: [
      SizedBox(
        height: 300.h,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SelectableText(errorMsg),
              ...frameList.map((e) {
                const githubUrl = 'https://hub.fastgit.xyz';
                final url =
                    '$githubUrl/SIT-kite/kite-app/blob/master/lib${e.uri.path.substring(4)}${e.line != null ? '#L${e.line}' : ''}';
                return TextButton(
                  onPressed: () => GlobalLauncher.launch(url),
                  child: Text(e.toString()),
                );
              }).toList(),
            ],
          ),
        ),
      )
    ], actionTextList: [
      '关闭'
    ]);
    return true;
  }
}
