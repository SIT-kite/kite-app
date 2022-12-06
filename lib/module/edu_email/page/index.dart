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
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';
import '../using.dart';
import '../init.dart';
import '../service/email.dart';
import 'item.dart';

String getEduEmail(String studentId) => "$studentId@mail.sit.edu.cn";

class MailPage extends StatefulWidget {
  const MailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  static const indexEmailList = 0;
  static const indexErrorPage = 1;
  int _index = indexEmailList; // 0 - 邮件列表, 1 - 错误页.
  List<MimeMessage>? _messages;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.eduEmailTitle.text(),
        actions: [_buildPopupMenu()],
      ),
      body: _buildBody(context),
    );
  }

  Future<void> _updateMailList() async {
    try {
      final messages = (await _loadMailList()).messages;
      // 日期越大的越靠前
      messages.sort((a, b) {
        return a.decodeDate()!.isAfter(b.decodeDate()!) ? -1 : 1;
      });
      if (!mounted) return;
      setState(() => _messages = messages);
    } catch (_) {
      if (!mounted) return;
      setState(() => _index = 1);
    }
  }

  Future<FetchImapResult> _loadMailList() async {
    final String studentId = Kv.auth.currentUsername ?? '';
    final String password = EduEmailInit.mail.password ?? (Kv.auth.ssoPassword ?? '');

    final email = getEduEmail(studentId);
    final service = MailService(email, password);

    return await service.getInboxMessage(30);
  }

  Widget _buildMailList() {
    final List<Widget> items = _messages!.map((e) {
      return Column(
        children: [
          MailItem(e),
          const Divider(),
        ],
      );
    }).toList();
    return ListView(children: items);
  }

  Widget _buildPwdInputBoxWhenFailed() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(image: AssetImage('assets/edu_email/figure_planet.png'), fit: BoxFit.cover),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 0.75.sw),
            /**
             * TODO: Email password?
             * "eduEmailLoginFailTip": "Failed to log in your edu email with OA Password. Troubleshooting:\n1.If you've never changed it, try all passwords you ever used.\n2."
             */
            child: Text(
              '登录失败，小风筝无法使用 OA 密码登录你的账户。\n'
              '这可能是信息中心未同步你的邮箱密码导致的。如果你未重置过该密码，它可能是你任意一次设置的 OA 密码。',
              style: Theme.of(context).textTheme.bodyText1,
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
                  EduEmailInit.mail.password = _controller.text;
                  setState(() => _index = indexEmailList);
                },
                child: i18n.continue_.text())
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
    } else {
      // _index == 1, 显示密码输入页
      return _buildPwdInputBoxWhenFailed();
    }
  }

  Widget _buildPopupMenu() {
    final String studentId = Kv.auth.currentUsername ?? '';
    final email = getEduEmail(studentId);

    return PopupMenuButton(itemBuilder: (_) => [PopupMenuItem(child: Text(email))]);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
