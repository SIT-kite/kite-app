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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kite/launcher.dart';

import '../entity/bulletin.dart';
import '../init.dart';
import '../using.dart';

class KiteBulletinPage extends StatelessWidget {
  const KiteBulletinPage({Key? key}) : super(key: key);

  _buildTitleText(BuildContext ctx, String title) {
    return Text(title, overflow: TextOverflow.ellipsis, style: Theme.of(ctx).textTheme.headline3);
  }

  _buildBulletinTitle(BuildContext ctx, KiteBulletin notice) {
    if (notice.top) {
      return Row(
        children: [const Icon(Icons.push_pin_rounded), _buildTitleText(ctx, notice.title)],
      );
    } else {
      return _buildTitleText(ctx, notice.title);
    }
  }

  Widget _buildBulletinItem(BuildContext context, KiteBulletin notice) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 标题, 注意遇到长标题时要折断
              Expanded(
                child: _buildBulletinTitle(context, notice),
              ),
              // 日期
              Text(context.dateNum(notice.publishTime), style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          // 正文
          MarkdownBody(
            data: notice.content ?? notice.title,
            selectable: true,
            onTapLink: (String text, String? href, String title) {
              GlobalLauncher.launch(href ?? '');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeList(BuildContext context, List<KiteBulletin> noticeList) {
    return SingleChildScrollView(
      child: Column(
        children: noticeList
            .map((e) => Card(
                  child: _buildBulletinItem(context, e),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildBody() {
    return MyFutureBuilder<List<KiteBulletin>>(
      future: KiteBulletinInit.noticeService.getNoticeList(),
      builder: (context, data) {
        return _buildNoticeList(context, data);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.ftype_kiteBulletin.txt),
      body: SafeArea(child: _buildBody()),
    );
  }
}
