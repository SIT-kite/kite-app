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
import 'package:kite/user_widget/webview_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'logger.dart';

Future<void> launchUrlInBrowser(String url) async {
  Log.info('启动浏览器打开页面：$url');
  await launchUrlString(url, mode: LaunchMode.externalApplication);
}

Future<void> launchUrlInBuiltinWebView(
  BuildContext context,
  String url, {
  String? fixedTitle,
}) async {
  Log.info('开启内置WebView加载URL: $url');
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SimpleWebViewPage(
        initialUrl: url,
        fixedTitle: fixedTitle,
      ),
    ),
  );
}
