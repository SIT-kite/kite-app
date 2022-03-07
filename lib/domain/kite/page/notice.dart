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
import 'package:kite/entity/kite/notice.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/domain/kite/service/index.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({Key? key}) : super(key: key);

  Widget _buildNoticeItem(BuildContext context, KiteNotice notice) {
    final dateFormat = DateFormat('yyyy / MM / dd');

    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                  flex: 3,
                  child: Text((notice.top ? '[置顶] ' : '') + notice.title,
                      overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline3),
                ),
                // 日期
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 90),
                    child: Text(dateFormat.format(notice.publishTime), style: const TextStyle(color: Colors.grey)),
                  ),
                )
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
        children: noticeList.map((e) => _buildNoticeItem(context, e)).toList(),
      ),
    );
  }

  Widget _buildBody() {
    final future = NoticeService(SessionPool.kiteSession).getNoticeList();

    return FutureBuilder<List<KiteNotice>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return _buildNoticeList(context, snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text('加载失败: ${snapshot.error.runtimeType.toString()}'));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('公告')),
      body: SafeArea(child: _buildBody()),
    );
  }
}
