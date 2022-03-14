import 'package:flutter/material.dart';
import 'package:kite/feature/web_page/webview/page/index.dart';

class BBSPage extends StatelessWidget {
  const BBSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SimpleWebViewPage(
      '',
      postData: {
        'openid': 'tucao_123',
        'nickname': 'tucao_test',
        'avatar': 'https://txc.qq.com/static/desktop/img/products/def-product-logo.png',
      },
      fixedTitle: '论坛',
    );
  }
}
