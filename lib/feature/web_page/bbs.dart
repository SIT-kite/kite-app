import 'package:flutter/material.dart';
import 'package:kite/setting/init.dart';

import 'webview/page/index.dart';

const _bbsUrl = 'https://support.qq.com/products/386124';

class BbsPage extends StatelessWidget {
  const BbsPage({Key? key}) : super(key: key);

  String _getNickname() {
    final srcName = SettingInitializer.auth.personName!;
    return srcName[0] + '同学';
  }

  @override
  Widget build(BuildContext context) {
    return SimpleWebViewPage(
      initialUrl: _bbsUrl,
      postData: {
        'openid': SettingInitializer.auth.currentUsername!,
        'nickname': _getNickname(),
        'avatar': 'https://txc.qq.com/static/desktop/img/products/def-product-logo.png',
      },
      fixedTitle: '问答',
      showLaunchButtonIfUnsupported: false,
    );
  }
}
