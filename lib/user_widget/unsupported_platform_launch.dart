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
import 'package:kite/launch.dart';

// TODO: Why not launch the default browser instead?
class UnsupportedPlatformUrlLauncher extends StatelessWidget {
  final String url;
  final String? tip;
  final bool showLaunchButton;
  const UnsupportedPlatformUrlLauncher(
    this.url, {
    Key? key,
    this.tip,
    this.showLaunchButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          tip == null
              ? Text(showLaunchButton ? '桌面端暂不支持直接查看该页面，请点击下方按钮打开系统默认浏览器查看该页面' : '桌面端暂不支持查看该页面，请在手机端打开')
              : Text(tip!),
          if (showLaunchButton)
            TextButton(
              child: const Text('点击在默认浏览器中打开'),
              onPressed: () {
                GlobalLauncher.launch(url);
              },
            )
        ],
      ),
    );
  }
}
