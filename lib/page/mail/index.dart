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
