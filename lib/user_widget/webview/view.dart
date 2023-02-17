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

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kite/user_widget/platform_widget.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/rule.dart';
import 'package:kite/util/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../unsupported_platform_launch.dart';

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
enum InjectJsTime {
  onPageStarted,
  onPageFinished,
}

class InjectJsRuleItem {
  /// js注入的url匹配规则
  Rule<String> rule;

  /// 若为空，则表示不注入
  String? javascript;

  /// 异步js字符串，若为空，则表示不注入
  Future<String?>? asyncJavascript;

  /// js注入时机
  InjectJsTime injectTime;

  InjectJsRuleItem({
    required this.rule,
    this.javascript,
    this.asyncJavascript,
    this.injectTime = InjectJsTime.onPageFinished,
  });
}

class MyWebView extends StatefulWidget {
  final WebViewController? controller;
  final String? initialUrl;

  /// js注入规则，判定某个url需要注入何种js代码
  final List<InjectJsRuleItem>? injectJsRules;

  /// 各种callback
  final void Function(String url)? onPageStarted;
  final void Function(String url)? onPageFinished;
  final void Function(int progress)? onProgress;

  final JavaScriptMode javaScriptMode;

  /// 若该字段不为null，则表示使用post请求打开网页
  final Map<String, String>? postData;

  /// 注入cookies
  final List<WebViewCookie> initialCookies;

  /// 自定义 UA
  final String? userAgent;

  /// 暴露dart回调到js接口
  final Map<String, void Function(JavaScriptMessage)>? javaScriptChannels;

  /// 如果不支持webview，是否显示浏览器打开按钮
  final bool showLaunchButtonIfUnsupported;

  const MyWebView({
    Key? key,
    this.controller,
    this.initialUrl,
    this.injectJsRules,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.javaScriptMode = JavaScriptMode.unrestricted, // js支持默认启用
    this.userAgent,
    this.postData,
    this.initialCookies = const <WebViewCookie>[],
    this.javaScriptChannels,
    this.showLaunchButtonIfUnsupported = true,
  }) : super(key: key);

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  late final _controller = widget.controller ?? WebViewController();

  @override
  void initState() {
    super.initState();

    if (_controller.platform is AndroidWebViewController) {
      (_controller.platform as AndroidWebViewController).setOnShowFileSelector(
        (FileSelectorParams params) async {
          FilePickerResult? fpr = await FilePicker.platform.pickFiles(dialogTitle: '请选择待上传文件');
          if (fpr == null) {
            return [];
          }
          List<String> paths = fpr.paths.where((e) => e != null).map((e) => 'file://${e!}').toList();
          Log.info(paths);
          return paths;
        },
      );
    }
    _controller
      ..setJavaScriptMode(widget.javaScriptMode)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) async {
          Log.info('开始加载url: $url');
          await Future.wait(getAllMatchJs(url, InjectJsTime.onPageStarted).map(injectJs));
          widget.onPageStarted?.call(url);
        },
        onPageFinished: (url) async {
          Log.info('url加载完毕: $url');
          await Future.wait(getAllMatchJs(url, InjectJsTime.onPageFinished).map(injectJs));
          widget.onPageFinished?.call(url);
        },
        onProgress: widget.onProgress,
        onWebResourceError: onResourceError,
      ))
      ..setUserAgent(widget.userAgent);

    if (widget.initialUrl != null) {
      Uri uri = Uri.parse(widget.initialUrl!);
      if (widget.postData == null) {
        _controller.loadRequest(uri);
      } else {
        _controller.loadRequest(
          uri,
          method: LoadRequestMethod.post,
        );
      }
    }

    if (widget.javaScriptChannels != null) {
      for (final e in widget.javaScriptChannels!.entries) {
        _controller.addJavaScriptChannel(e.key, onMessageReceived: e.value);
      }
    }

    // WebViewCookieManager似乎是全局单例的？
    final cookieManager = WebViewCookieManager();
    widget.initialCookies.forEach(cookieManager.setCookie);
  }

  @override
  Widget build(BuildContext context) {
    return MyPlatformWidget(
      desktopOrWebBuilder: (context) {
        return UnsupportedPlatformUrlLauncher(
          widget.initialUrl ?? '',
          showLaunchButton: widget.showLaunchButtonIfUnsupported,
        );
      },
      mobileBuilder: (context) {
        return WebViewWidget(
          controller: _controller,
        );
      },
    );
  }

  /// 获取该url匹配的所有注入项
  Iterable<InjectJsRuleItem> getAllMatchJs(String url, InjectJsTime injectTime) {
    final rules = widget.injectJsRules
        ?.where((injectJsRule) => injectJsRule.rule.accept(url) && injectJsRule.injectTime == injectTime);
    return rules ?? [];
  }

  /// 根据当前url筛选所有符合条件的js脚本，执行js注入
  Future<void> injectJs(InjectJsRuleItem injectJsRule) async {
    // 同步获取js代码
    if (injectJsRule.javascript != null) {
      Log.info('执行了js注入');
      await _controller.runJavaScript(injectJsRule.javascript!);
    }
    // 异步获取js代码
    if (injectJsRule.asyncJavascript != null) {
      String? js = await injectJsRule.asyncJavascript;
      if (js != null) {
        await _controller.runJavaScript(js);
      }
    }
  }

  void onResourceError(WebResourceError error) async {
    String? url = await _controller.currentUrl();
    if (url == null) {
      return;
    }
    if (url.startsWith('http')) {
      return;
    }
    launchUrlInBrowser(url);
    _controller.goBack();
  }
}
