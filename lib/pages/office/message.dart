import 'package:flutter/material.dart';
import 'package:kite/services/office/office.dart';

class MessagePage extends StatelessWidget {
  final OfficeSession session;
  const MessagePage(this.session, {Key? key}) : super(key: key);

  Widget buildMessageList(List<OfficeMessageSummary> messageList) {
    return ListView(
      children: messageList
          .map((e) => ListTile(
                title: Text(e.functionName),
                subtitle: Text('最近更新: ' + e.recentStep),
                trailing: Text(e.status),
              ))
          .toList(),
    );
  }

  Widget buildBody() {
    return FutureBuilder<OfficeMessagePage>(
      future: getAllMessage(session),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final OfficeMessagePage page = snapshot.data!;
          return buildMessageList(page.msgList);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('我的消息')), body: buildBody());
  }
}
