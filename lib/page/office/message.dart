import 'package:flutter/material.dart';
import 'package:kite/entity/office.dart';
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
