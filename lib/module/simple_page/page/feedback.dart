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
import 'dart:io';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../using.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyFutureBuilder<List>(
      futureGetter: () => Future.wait([
        () async {
          try {
            return await PackageInfo.fromPlatform();
          } catch (e) {
            return null;
          }
        }(),
        Global.ssoSession.checkConnectivity(),
        () async {
          try {
            return FkUserAgent.webViewUserAgent;
          } catch (e) {
            return null;
          }
        }(),
      ]),
      builder: (ctx, data) {
        final PackageInfo? packageInfo = data[0];
        final bool isConnected = data[1];
        final String? ua = data[2];
        return SimpleWebViewPage(
          initialUrl: R.kiteFeedbackUrl,
          showLoadInBrowser: true,
          fixedTitle: i18n.feedback,
          postData: {
            'clientInfo': ua ?? '无UA信息',
            'clientVersion': "${packageInfo?.version ?? '未知'}+${packageInfo?.buildNumber ?? '未知'}",
            'os': Platform.operatingSystem,
            'osVersion': Platform.operatingSystemVersion,
            'netType': isConnected ? '已连接校园网' : '未连接校园网',
          },
        );
      },
    );
  }
}
