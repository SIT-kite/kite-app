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
import 'package:intl/intl.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/home/entity/home.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/util/dsl.dart';

import '../init.dart';
import 'entity.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({Key? key}) : super(key: key);

  Widget _buildNoticeItem(BuildContext context, KiteNotice notice) {
    return InkWell(
      onTap: () {},
      child: Padding(
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
                  child: Text((notice.top ? '${i18n.kiteBuiltinPinned} ' : '') + notice.title,
                      overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline3),
                ),
                // 日期
                Text(context.dateNum(notice.publishTime), style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            // 正文
            Text(notice.content ?? notice.title)
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeList(BuildContext context, List<KiteNotice> noticeList) {
    return SingleChildScrollView(
      child: Column(
        children: noticeList
            .map((e) => Column(
                  children: [
                    _buildNoticeItem(context, e),
                    const Divider(),
                  ],
                ))
            .toList(),
      ),
    );
  }

  Widget _buildBody() {
    return MyFutureBuilder<List<KiteNotice>>(
      future: KiteInitializer.noticeService.getNoticeList(),
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
