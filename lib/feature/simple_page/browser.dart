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

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite/component/webview.dart';
import 'package:kite/component/webview_page.dart';
import 'package:kite/util/rule.dart';

class BrowserPage extends StatelessWidget {
  /// 初始的url
  final String initialUrl;

  /// 固定的标题名？若为null则自动获取目标页面标题
  final String? fixedTitle;

  /// 显示分享按钮(默认不显示)
  final bool? showSharedButton;

  /// 显示刷新按钮(默认显示)
  final bool? showRefreshButton;

  /// 显示在浏览器中打开按钮(默认不显示)
  final bool? showLoadInBrowser;

  /// 自定义 UA
  final String? userAgent;

  /// 如果不支持webview，是否显示浏览器打开按钮
  final bool? showLaunchButtonIfUnsupported;

  /// 是否显示顶部进度条
  final bool? showTopProgressIndicator;

  /// JS注入
  final String? javascript;

  /// 通过url获取js代码
  final String? javascriptUrl;

  const BrowserPage({
    Key? key,
    required this.initialUrl,
    this.fixedTitle,
    this.showSharedButton,
    this.showRefreshButton,
    this.showLoadInBrowser,
    this.userAgent,
    this.showLaunchButtonIfUnsupported,
    this.showTopProgressIndicator,
    this.javascript,
    this.javascriptUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<InjectJsRuleItem> injectJsRules = [
      InjectJsRuleItem(
        rule: const ConstRule<String>(true),
        javascript: javascript,
        asyncJavascript:
            javascriptUrl == null ? null : Dio().get<String>(javascriptUrl!).asStream().map((e) => e.data).first,
      ),
    ];

    return SimpleWebViewPage(
      initialUrl: initialUrl,
      fixedTitle: fixedTitle,
      showSharedButton: showSharedButton ?? false,
      showRefreshButton: showRefreshButton ?? true,
      showLoadInBrowser: showLoadInBrowser ?? true,
      userAgent: userAgent,
      showLaunchButtonIfUnsupported: showLaunchButtonIfUnsupported ?? true,
      showTopProgressIndicator: showTopProgressIndicator ?? true,
      injectJsRules: javascript == null ? null : injectJsRules,
    );
  }
}
