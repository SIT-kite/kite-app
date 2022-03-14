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
import 'package:intl/intl.dart';

import 'detail.dart';

class MailItem extends StatelessWidget {
  static final dateFormat = DateFormat('MM-dd');

  final MimeMessage _message;

  const MailItem(this._message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline5;
    final subtitleStyle = Theme.of(context).textTheme.bodyText2;
    final contentStyle = Theme.of(context).textTheme.bodyText2;

    final subjectText = _message.decodeSubject() ?? '无主题';
    final sender = _message.decodeSender();
    final senderText = sender[0].toString() + (sender.length > 1 ? '等' : '');
    final contentText = _message.decodeTextPlainPart() ?? '';
    final date = _message.decodeDate();
    final dateText = date != null ? dateFormat.format(date) : '';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          subjectText[0],
          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey[50]),
        ),
        radius: 20,
      ),
      isThreeLine: true,
      title: Text(subjectText, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(senderText, style: subtitleStyle),
        Text(contentText, style: contentStyle, maxLines: 1, overflow: TextOverflow.ellipsis)
      ]),
      trailing: Text(dateText, style: subtitleStyle),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(_message)));
      },
    );
  }
}
