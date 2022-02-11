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
import 'package:enough_mail/imap/response.dart';
import 'package:enough_mail/mime_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/service/mail.dart';

import 'item.dart';

class MailPage extends StatefulWidget {
  const MailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  int _index = 0; // 0 - 邮件列表, 1 - 错误页.
  List<MimeMessage>? _messages;

  final TextEditingController _controller = TextEditingController();

  Future<void> _updateMailList() async {
    try {
      final messages = (await _loadMailList()).messages;
      setState(() => _messages = messages);
    } catch (_) {
      setState(() => _index = 1);
    }
  }

  Future<FetchImapResult> _loadMailList() async {
    final String studentId = StoragePool.authSetting.currentUsername ?? '';
    final String password = StoragePool.mail.password ?? StoragePool.authPool.get(studentId)!.password;

    final email = studentId + '@mail.sit.edu.cn';
    final service = MailService(email, password);

    return await service.getInboxMessage(30);
  }

  Widget _buildMailList() {
    final List<Widget> items = _messages!.map((e) => MailItem(e)).toList();
    return ListView(children: items);
  }

  Widget _buildInputPassword() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("assets/mail/figure_planet.png"),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 0.75.sw),
            child: Text(
              '登录失败，小风筝无法使用 OA 密码登录你的账户。\n'
              '这可能是信息中心未同步你的邮箱密码导致的。如果你未重置过该密码，它可能是你任意一次设置的 OA 密码。',
              style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.black54),
            ),
          ),
          Row(mainAxisSize: MainAxisSize.min, children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 0.6.sw),
              child: TextField(
                  controller: _controller, decoration: const InputDecoration(hintText: '密码'), obscureText: true),
            ),
            ElevatedButton(
                onPressed: () {
                  StoragePool.mail.password = _controller.text;
                  setState(() => _index = 0);
                },
                child: const Text('继续'))
          ]),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // 如果当前加载邮件列表
    if (_index == 0) {
      // 如果是首次加载, 拉取数据并显示加载动画
      if (_messages == null) {
        _updateMailList();
        return const Center(child: CircularProgressIndicator());
      }
      // 非首次加载, 即已获取邮件列表, 直接渲染即可
      return _buildMailList();
    }
    // _index == 1, 显示密码输入页
    return _buildInputPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的邮件'),
      ),
      body: _buildBody(context),
    );
  }
}
