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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/launcher.dart';
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
