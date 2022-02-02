import 'package:enough_mail/imap/response.dart';
import 'package:flutter/material.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/service/mail.dart';

class MailPage extends StatelessWidget {
  late final emailAddress;
  late final mailService;

  MailPage({Key? key}) : super(key: key) {
    final String studentId = StoragePool.authSetting.currentUsername ?? '';
    final String password = StoragePool.authPool.get(studentId)!.password;

    emailAddress = studentId + '@mail.sit.edu.cn';
    mailService = MailService(emailAddress, password);
  }

  Widget _buildMailList(FetchImapResult fetchResult) {
    final List<Widget> items = fetchResult.messages
        .map(
          (e) => ListTile(title: Text(e.decodeSubject() ?? '无主题')),
        )
        .toList();
    return ListView(
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的邮件'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
      ),
      body: FutureBuilder<FetchImapResult>(
        future: mailService.getInboxMessage(1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final FetchImapResult mailResult = snapshot.data!;
              return _buildMailList(mailResult);
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
