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
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import '../entity/message.dart';
import '../user_widget/mail.dart';
import '../using.dart';

import '../init.dart';

class Mailbox extends StatefulWidget {
  const Mailbox({super.key});

  @override
  State<Mailbox> createState() => _MailboxState();
}

class _MailboxState extends State<Mailbox> {
  ApplicationMsgPage? _msgPage;

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

  Widget _buildMessageList(BuildContext context, List<ApplicationMsg> list) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final count = constraints.maxWidth ~/ 300;
      return LiveGrid.options(
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
        ),
        options: kiteLiveOptions,
        itemBuilder: (ctx, index, animation) => Mail(msg: list[index]).aliveWith(animation),
      );
    });
  }
}
