import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kite/component/webview.dart';
import 'package:kite/component/webview_page.dart';
import 'package:kite/feature/game/util/upload.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/rule.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../entity/game.dart';

class ComposeSitPage extends StatelessWidget {
  const ComposeSitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleWebViewPage(
      initialUrl: 'https://cdn.kite.sunnysab.cn/game/composeSit',
      showLoadInBrowser: true,
      injectJsRules: [
        InjectJsRuleItem(injectTime: InjectJsTime.onPageStarted, rule: FunctionalRule((x) => true), javascript: '''
function uploadGameRecord(obj){
  KiteGame.postMessage(JSON.stringify(obj));
}''')
      ],
      javascriptChannels: {
        JavascriptChannel(
          name: 'KiteGame',
          onMessageReceived: (JavascriptMessage message) async {
            Log.info('收到上传游戏记录请求${message.message}');
            final record = GameRecord.fromJson(jsonDecode(message.message));

            Log.info('上传游戏记录$record');
            record.ts = DateTime.now();

            await uploadGameRecord(context, record);
          },
        ),
      },
    );
  }
}
