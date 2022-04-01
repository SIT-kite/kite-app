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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/launch.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/scanner.dart';
import 'package:universal_platform/universal_platform.dart';

import 'index.dart';

class ScanItem extends StatelessWidget {
  const ScanItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeFunctionButton(
      onPressd: () async {
        if (UniversalPlatform.isDesktopOrWeb) {
          showAlertDialog(
            context,
            title: '不支持的功能',
            content: [const Text('仅移动端支持该功能')],
            actionTextList: ['OK'],
          );
          return;
        }
        final result = await scan(context);
        Log.info('扫码结果: $result');
        if (result != null) GlobalLauncher.launch(result);
      },
      // icon: 'assets/home/icon_bbs.svg',
      iconWidget: Icon(Icons.qr_code_scanner, size: 30.h, color: Theme.of(context).primaryColor),
      title: '扫码',
      subtitle: '扫描各种二维码',
    );
  }
}
