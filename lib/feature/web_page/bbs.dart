import 'package:flutter/material.dart';
import 'package:kite/component/webview_page.dart';
import 'package:kite/setting/dao/index.dart';
import 'package:kite/setting/init.dart';

const _bbsUrl = 'https://support.qq.com/products/386124';

class BbsPage extends StatelessWidget {
  BbsPage({Key? key}) : super(key: key);

  final isFreshman = SettingInitializer.auth.userType == UserType.freshman;

  String _getNickname() {
    final srcName = SettingInitializer.auth.personName!;
    final userType = SettingInitializer.auth.userType!;
    return srcName[0] + (userType != UserType.teacher ? '同学' : '老师');
  }

  @override
  Widget build(BuildContext context) {
    String openid = '';
    if (isFreshman) {
      openid = SettingInitializer.auth.freshmanAccount!;
    } else {
      openid = SettingInitializer.auth.currentUsername!;
    }
    return SimpleWebViewPage(
      initialUrl: _bbsUrl,
      postData: {
        'openid': openid,
        'nickname': _getNickname(),
        'avatar': 'https://txc.qq.com/static/desktop/img/products/def-product-logo.png',
      },
      fixedTitle: '问答',
      showLaunchButtonIfUnsupported: false,
    );
  }
}
