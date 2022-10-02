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
import 'package:kite/user_widget/html_widget.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/util/dsl.dart';

import '../entity.dart';

class LibraryNoticePage extends StatelessWidget {
  final Notice notice;
  final bool isHtml;

  const LibraryNoticePage(this.notice, {Key? key, this.isHtml = true}) : super(key: key);

  buildPlainText(Notice notice) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        child: Text(
          notice.html,
          style: const TextStyle(fontSize: 20),
          overflow: TextOverflow.visible,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: i18n.libraryNoticeTitle.txt,
        ),
        body: isHtml ? MyHtmlWidget(notice.html) : buildPlainText(notice));
  }
}
