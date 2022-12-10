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

import 'dart:convert';

import 'package:flutter/material.dart';
import '../../user_widgets/dialog.dart';
import '../../using.dart';

import '../../entity/record.dart';
import '../common.dart';

class GameComposeSitPage extends StatelessWidget {
  const GameComposeSitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => await showLeaveGameRequest(context),
        child: SimpleWebViewPage(
          initialUrl: '${Backend.kite}/game/composeSit',
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
                final oaUser = Auth.oaUser;
                if (oaUser != null) {
                  Log.info('收到上传游戏记录请求${message.message}');
                  final record = GameRecord.fromJson(jsonDecode(message.message));

                  Log.info('上传游戏记录$record');
                  record.ts = DateTime.now();

                  await uploadGameRecord(context, oaUser, record);
                }
              },
            ),
          },
        ));
  }
}
