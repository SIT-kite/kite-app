import 'package:flutter/material.dart';
import 'package:kite/component/webview_page.dart';
import 'package:kite/setting/dao/index.dart';
import 'package:kite/setting/init.dart';
import 'package:kite/util/logger.dart';

const _bbsUrl = 'https://support.qq.com/products/386124';

class BbsPage extends StatelessWidget {
  const BbsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFreshman = SettingInitializer.auth.userType == UserType.freshman;

    String openid = '';
    String nickname = '';
    if (isFreshman) {
      openid = SettingInitializer.freshman.freshmanAccount!;
      nickname = SettingInitializer.freshman.freshmanName!;
    } else {
      openid = SettingInitializer.auth.currentUsername!;
      nickname = SettingInitializer.auth.personName!;
    }
    if (SettingInitializer.auth.userType == UserType.teacher) {
      nickname = '${nickname[0]}老师';
    } else {
      nickname = '${nickname[0]}同学';
    }
    Log.info('BBS身份：{openid: $openid, nickname: $nickname}');
    return SimpleWebViewPage(
      initialUrl: _bbsUrl,
      postData: {
        'openid': openid,
        'nickname': nickname,
        'avatar': 'https://txc.qq.com/static/desktop/img/products/def-product-logo.png',
      },
      fixedTitle: '问答',
      showLaunchButtonIfUnsupported: false,
    );
  }
}
