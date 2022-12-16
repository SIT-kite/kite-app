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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:kite/global/init.dart';
import 'package:kite/migration/migrations.dart';
import 'package:kite/util/kite_catcher_handler.dart';

import 'app.dart';
import 'backend.dart';
import 'package:ikite/ikite.dart';
import 'package:ikite_flutter/ikite_flutter.dart';

import 'ikite.dart';

const exceptionLogUrl = '${Backend.kite}/api/v2/report/exception';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Migrations.init();
  iKite.install(DefaultFlutterDataAdapterPlugin);
  iKite.install(KiteAppDataAdapterPlugin);
  await Initializer.init();
  CatcherOptions buildCatcherConfig(bool releaseMode) => CatcherOptions(
        // 对话框和新页面的方式不是很好汉化, 且程序中存在连续抛异常的情况, 为不打扰用户直接静默上报
        SilentReportMode(),
        [
          ConsoleHandler(),
          KiteDialogHandler(),
          KiteToastHandler(),
          if (releaseMode)
            HttpHandler(HttpRequestType.post, Uri.parse(exceptionLogUrl), requestTimeout: 5000, printLogs: true),
        ],
      );
  Catcher(
    rootWidget: Phoenix(child: const KiteApp()),
    releaseConfig: buildCatcherConfig(true),
    debugConfig: buildCatcherConfig(false),
  );
}
