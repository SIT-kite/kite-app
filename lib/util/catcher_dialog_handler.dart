import 'package:catcher/catcher.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kite/launch.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:stack_trace/stack_trace.dart';

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
    if (KvStorageInitializer.developOptions.showErrorInfoDialog == null) return true;
    if (!KvStorageInitializer.developOptions.showErrorInfoDialog!) return true;

    Trace trace = Trace.from(error.stackTrace);
    final frameList = trace.frames.where((e) => e.uri.path.startsWith('kite')).toList();
    showAlertDialog(
      context,
      title: '程序异常信息',
      content: <Widget>[
        Text(error.error.toString()),
        ...frameList.map((e) {
          final url =
              'https://github.com/SIT-kite/kite-app/blob/master/lib${e.uri.path.substring(4)}${e.line != null ? '#L${e.line}' : ''}';
          return TextButton(
            onPressed: () => GlobalLauncher.launch(url),
            child: Text(e.toString()),
          );
        }).toList(),
      ],
    );
    return true;
  }
}
