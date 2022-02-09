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
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatelessWidget {
  static final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

  final MimeMessage _message;

  const DetailPage(this._message, {Key? key}) : super(key: key);

  Widget _buildBody(BuildContext context) {
    final html = _message.decodeTextHtmlPart() ?? '';
    final titleStyle = Theme.of(context).textTheme.headline2?.copyWith(fontWeight: FontWeight.bold);
    final subtitleStyle = Theme.of(context).textTheme.headline4?.copyWith(color: Colors.black54);

    final subjectText = _message.decodeSubject() ?? '无主题';
    final sender = _message.decodeSender();
    final senderText = sender[0].toString() + (sender.length > 1 ? '等' : '');
    final date = _message.decodeDate();
    final dateText = date != null ? dateFormat.format(date) : '';

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(subjectText, style: titleStyle),
          Text('$senderText\n$dateText', style: subtitleStyle),
          Expanded(
            child: WebView(
              onWebViewCreated: (controller) => controller.loadHtmlString(html),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('正文')),
      body: _buildBody(context),
    );
  }
}
