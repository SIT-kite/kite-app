/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';
import 'package:kite/entity/office/index.dart';
import 'package:kite/service/office/index.dart';

import 'browser.dart';

class MessagePage extends StatelessWidget {
  final OfficeSession session;

  const MessagePage(this.session, {Key? key}) : super(key: key);

  Widget _buildMessageList(BuildContext context, List<OfficeMessageSummary> messageList) {
    return ListView(
      children: messageList
          .map(
            (e) => ListTile(
              title: Text(e.functionName),
              subtitle: Text('最近更新: ' + e.recentStep),
              trailing: Text(e.status),
              onTap: () {
                // 跳转到详情页面
                final String resultUrl =
                    'https://xgfy.sit.edu.cn/unifri-flow/WF/mobile/index.html?ismobile=1&FK_Flow=${e.functionId}&WorkID=${e.flowId}&IsReadonly=1&IsView=1';
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => BrowserPage(e.functionName, resultUrl)));
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<OfficeMessagePage>(
      future: getAllMessage(session),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final OfficeMessagePage page = snapshot.data!;
          return _buildMessageList(context, page.msgList);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('我的消息')), body: _buildBody());
  }
}
