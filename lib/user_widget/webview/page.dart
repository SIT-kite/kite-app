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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/design/utils.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/launcher.dart';
import 'package:kite/user_widget/webview/view.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/rule.dart';
import 'package:kite/util/url_launcher.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SimpleWebViewPage extends StatefulWidget {
  /// 初始的url
  final String initialUrl;

  /// 固定的标题名？若为null则自动获取目标页面标题
  final String? fixedTitle;

  /// js注入规则
  final List<InjectJsRuleItem>? injectJsRules;

  /// 显示分享按钮(默认不显示)
  final bool showSharedButton;

  /// 显示刷新按钮(默认显示)
  final bool showRefreshButton;

  /// 显示在浏览器中打开按钮(默认不显示)
  final bool showLoadInBrowser;

  /// 浮动按钮控件
  final Widget? floatingActionButton;

  /// 自定义 UA
  final String? userAgent;

  /// 若该字段不为null，则表示使用post请求打开网页
  final Map<String, String>? postData;

  /// WebView创建完毕时的回调
  final WebViewCreatedCallback? onWebViewCreated;

  /// 异步注入cookie
  final Future<List<WebViewCookie>>? initialAsyncCookies;

  /// 暴露dart回调到js接口
  final Set<JavascriptChannel>? javascriptChannels;

  /// 如果不支持 WebView，是否显示浏览器打开按钮
  final bool showLaunchButtonIfUnsupported;

  /// 是否显示顶部进度条
  final bool showTopProgressIndicator;

  /// 自定义Action按钮
  final List<Widget>? otherActions;

  /// 夜间模式
  final bool followDarkMode;

  const SimpleWebViewPage({
    Key? key,
    required this.initialUrl,
    this.fixedTitle,
    this.injectJsRules,
    this.floatingActionButton,
    this.onWebViewCreated,
    this.showSharedButton = false,
    this.showRefreshButton = true,
    this.showLoadInBrowser = false,
    this.showTopProgressIndicator = true,
    this.userAgent,
    this.postData,
    this.initialAsyncCookies,
    this.javascriptChannels,
    this.showLaunchButtonIfUnsupported = true,
    this.otherActions,
    this.followDarkMode = true,
  }) : super(key: key);

  @override
  State<SimpleWebViewPage> createState() => _SimpleWebViewPageState();
}

class _SimpleWebViewPageState extends State<SimpleWebViewPage> {
  final _controllerCompleter = Completer<WebViewController>();
  String title = i18n.untitled;
  int progress = 0;

  void _onRefresh() async {
    final controller = await _controllerCompleter.future;
    await controller.reload();
  }

  void _onShared() async {
    final controller = await _controllerCompleter.future;
    Log.info('分享页面: ${await controller.currentUrl()}');
  }

  /// 构造进度条
  PreferredSizeWidget buildTopIndicator() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(3.0),
      child: LinearProgressIndicator(
        backgroundColor: Colors.white70.withOpacity(0),
        value: progress / 100,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isDesktop) {
      Navigator.of(context).pop();
      GlobalLauncher.launch(widget.initialUrl);
      return Container();
    }
    final actions = <Widget>[
      if (widget.showSharedButton)
        IconButton(
          onPressed: _onShared,
          icon: const Icon(Icons.share),
        ),
      if (widget.showRefreshButton)
        IconButton(
          onPressed: _onRefresh,
          icon: const Icon(Icons.refresh),
        ),
      if (widget.showLoadInBrowser)
        IconButton(
          onPressed: () => launchUrlInBrowser(widget.initialUrl),
          icon: const Icon(Icons.open_in_browser),
        ),
      ...?widget.otherActions,
    ];
    final curTitle = widget.fixedTitle ?? title;
    return WillPopScope(
      onWillPop: () async {
        final controller = await _controllerCompleter.future;
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(curTitle),
          actions: actions,
          bottom: widget.showTopProgressIndicator ? buildTopIndicator() : null,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButton: widget.floatingActionButton,
        body: MyWebView(
          initialUrl: widget.initialUrl,
          onWebViewCreated: (controller) async {
            _controllerCompleter.complete(controller);
            if (widget.onWebViewCreated != null) {
              widget.onWebViewCreated!(controller);
            }
          },
          injectJsRules: () {
            if (!widget.followDarkMode) return null;
            return [
              if (Theme.of(context).isDark)
                InjectJsRuleItem(
                  rule: const ConstRule(true),
                  asyncJavascript: rootBundle.loadString('assets/webview/dark.js'),
                  injectTime: InjectJsTime.onPageFinished,
                ),
              if (widget.injectJsRules != null) ...widget.injectJsRules!,
            ];
          }(),
          onProgress: (value) {
            if (!mounted) return;
            setState(() => progress = value % 100);
          },
          onPageFinished: (url) async {
            if (widget.fixedTitle == null) {
              final controller = await _controllerCompleter.future;
              title = (await controller.getTitle()) ?? i18n.untitled;
              if (!mounted) return;
              setState(() {});
            }
          },
          javascriptChannels: widget.javascriptChannels,
          userAgent: widget.userAgent,
          postData: widget.postData,
          initialAsyncCookies: widget.initialAsyncCookies,
          showLaunchButtonIfUnsupported: widget.showLaunchButtonIfUnsupported,
        ),
      ),
    );
  }
}
