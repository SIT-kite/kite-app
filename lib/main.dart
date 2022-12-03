/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:kite/global/init.dart';
import 'package:kite/util/catcher_dialog_handler.dart';
import 'package:universal_platform/universal_platform.dart';

import 'app.dart';
import 'backend.dart';

const exceptionLogUrl = '${Backend.kite}/api/v2/report/exception';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Initializer.init();

  Catcher(
    rootWidget: Phoenix(
      child: const KiteApp(),
    ),
    releaseConfig: CatcherOptions(
      // 对话框和新页面的方式不是很好汉化, 且程序中存在连续抛异常的情况, 为不打扰用户直接静默上报
      SilentReportMode(),
      [
        ConsoleHandler(),
        DialogHandler(),
        if (!UniversalPlatform.isDesktopOrWeb)
          ToastHandler(backgroundColor: Colors.black38, customMessage: '程序好像有点小问题'), // 这里给用户一点提示, 避免出错时用户感到奇怪
        HttpHandler(HttpRequestType.post, Uri.parse(exceptionLogUrl), requestTimeout: 5000, printLogs: true),
      ],
    ),
    debugConfig: CatcherOptions(
      // 对话框和新页面的方式不是很好汉化, 且程序中存在连续抛异常的情况, 为不打扰用户直接静默上报
      SilentReportMode(),
      [
        ConsoleHandler(),
        DialogHandler(),
        if (!UniversalPlatform.isDesktopOrWeb)
          ToastHandler(backgroundColor: Colors.black38, customMessage: '程序好像有点小问题'), // 这里给用户一点提示, 避免出错时用户感到奇怪
      ],
    ),
  );
}
