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
import 'package:flutter/material.dart';
import 'package:kite/design/page/common.dart';
import 'package:rettulf/rettulf.dart';
import '../entity/message.dart';
import '../using.dart';

import '../init.dart';
import 'browser.dart';

class Mailbox extends StatefulWidget {
  const Mailbox({super.key});

  @override
  State<Mailbox> createState() => _MailboxState();
}

class _MailboxState extends State<Mailbox> {
  OfficeMessagePage? _msgPage;

  @override
  void initState() {
    super.initState();
    ApplicationInit.messageService.getAllMessage().then((value) {
      if (!mounted) return;
      setState(() {
        _msgPage = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final msg = _msgPage;

    if (msg == null) {
      return Placeholders.loading();
    } else {
      if (msg.msgList.isNotEmpty) {
        return _buildMessageList(context, msg.msgList);
      } else {
        return LeavingBlank(icon: Icons.upcoming_outlined, desc: i18n.applicationMailboxEmptyTip);
      }
    }
  }

  Widget _buildMessageList(BuildContext context, List<OfficeMessageSummary> messageList) {
    return ListView(
      children: messageList
          .map(
            (e) => ListTile(
              title: Text(e.functionName),
              subtitle: Text('${i18n.applicationMailboxRecent}: ${e.recentStep}'),
              trailing: Text(e.status),
              onTap: () {
                // 跳转到详情页面
                final String resultUrl =
                    'https://xgfy.sit.edu.cn/unifri-flow/WF/mobile/index.html?ismobile=1&FK_Flow=${e.functionId}&WorkID=${e.flowId}&IsReadonly=1&IsView=1';
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => InAppViewPage(title: e.functionName, url: resultUrl)));
              },
            ),
          )
          .toList(),
    );
  }
}
