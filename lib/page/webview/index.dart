import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kite/component/webview.dart';
import 'package:kite/util/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SimpleWebViewPage extends StatefulWidget {
  /// 初始的url
  final String initialUrl;

  /// 固定的标题名？若为null则自动获取目标页面标题
  final String? fixedTitle;

  /// js注入规则
  final List<InjectJsRuleItem>? injectJsRules;
  const SimpleWebViewPage(
    this.initialUrl, {
    Key? key,
    this.fixedTitle,
    this.injectJsRules,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: _onShared,
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: MyWebView(
        initialUrl: widget.initialUrl,
        onWebViewCreated: (controller) async {
          _controllerCompleter.complete(controller);
        },
        injectJsRules: widget.injectJsRules,
        onPageFinished: (url) async {
          final controller = await _controllerCompleter.future;
          title = (await controller.getTitle()) ?? '无标题页面';
          setState(() {});
        },
      ),
    );
  }
}
