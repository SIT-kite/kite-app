import 'package:flutter/material.dart';
import 'package:kite/feature/web_page/webview/page/index.dart';

class ComposeSitPage extends StatelessWidget {
  const ComposeSitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SimpleWebViewPage(
      initialUrl: 'https://cdn.kite.sunnysab.cn/game/composeSit',
      showLoadInBrowser: true,
    );
  }
}
