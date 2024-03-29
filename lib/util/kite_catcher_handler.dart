/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:catcher/catcher.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kite/design/user_widgets/dialog.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/launcher.dart';
import 'package:kite/storage/init.dart';
import 'package:stack_trace/stack_trace.dart';

import 'logger.dart';

class KiteDialogHandler extends ReportHandler {
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
    await context.showAnyTip(
      title: i18n.exceptionInfo,
      ok: i18n.close,
      make: (ctx) => SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SelectableText(errorMsg),
              ...frameList.asMap().entries.map((entry) {
                final index = entry.key;
                final e = entry.value;
                // const githubUrl = 'https://hub.fastgit.xyz';
                const githubUrl = 'https://github.com';
                final url =
                    '$githubUrl/SIT-kite/kite-app/blob/master/lib${e.uri.path.substring(4)}${e.line != null ? '#L${e.line}' : ''}';
                return Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        enableFeedback: false,
                        shape: const RoundedRectangleBorder()),
                    onPressed: () => GlobalLauncher.launch(url),
                    child: Text("[#$index] $e"),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
    return true;
  }
}

class KiteToastHandler extends ReportHandler {
  @override
  String toString() {
    return 'MyToastHandler';
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
    EasyLoading.showToast(
      '程序好像有点小问题',
      toastPosition: EasyLoadingToastPosition.bottom,
    );
    return true;
  }
}
