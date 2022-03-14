import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kite/component/webview.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/url_launcher.dart';
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
    this.userAgent,
    this.postData,
    this.initialAsyncCookies,
    this.javascriptChannels,
  }) : super(key: key);

  @override
  _SimpleWebViewPageState createState() => _SimpleWebViewPageState();
}

class _SimpleWebViewPageState extends State<SimpleWebViewPage> {
  final _controllerCompleter = Completer<WebViewController>();
  String title = '无标题页面';

  void _onRefresh() async {
    final controller = await _controllerCompleter.future;
    await controller.reload();
  }

  void _onShared() async {
    final controller = await _controllerCompleter.future;
    Log.info('分享页面: ${controller.currentUrl()}');
  }

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];
    if (widget.showSharedButton) {
      actions.add(IconButton(
        onPressed: _onShared,
        icon: const Icon(Icons.share),
      ));
    }
    if (widget.showRefreshButton) {
      actions.add(IconButton(
        onPressed: _onRefresh,
        icon: const Icon(Icons.refresh),
      ));
    }
    if (widget.showLoadInBrowser) {
      actions.add(IconButton(
        onPressed: () => launchInBrowser(widget.initialUrl),
        icon: const Icon(Icons.open_in_browser),
      ));
    }
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
          title: Text(widget.fixedTitle == null ? title : widget.fixedTitle!),
          actions: actions,
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
          injectJsRules: widget.injectJsRules,
          onPageFinished: (url) async {
            if (widget.fixedTitle == null) {
              final controller = await _controllerCompleter.future;
              title = (await controller.getTitle()) ?? '无标题页面';
              setState(() {});
            }
          },
          javascriptChannels: widget.javascriptChannels,
          userAgent: widget.userAgent,
          postData: widget.postData,
          initialAsyncCookies: widget.initialAsyncCookies,
        ),
      ),
    );
  }
}
