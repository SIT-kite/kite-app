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
import '../using.dart';

import '../entity/announcement.dart';
import '../entity/page.dart';
import '../init.dart';
import 'detail.dart';

class OaAnnouncePage extends StatelessWidget {
  const OaAnnouncePage({Key? key}) : super(key: key);

  Widget _buildBulletinItem(BuildContext context, BulletinRecord record) {
    final titleStyle = Theme.of(context).textTheme.headline4;
    final subtitleStyle = Theme.of(context).textTheme.bodyText1;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: ListTile(
        title: Text(record.title, style: titleStyle, overflow: TextOverflow.ellipsis),
        subtitle: Text('${record.department} | ${context.dateNum(record.dateTime)}', style: subtitleStyle),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(record))),
      ),
    );
  }

  Future<List<BulletinRecord>> _queryBulletinListInAllCategory(int page) async {
    // Make sure login.
    await OaAnnouncementInit.session.request('https://myportal.sit.edu.cn/', ReqMethod.get);

    final service = OaAnnouncementInit.bulletin;

    // 获取所有分类
    final catalogues = await service.getAllCatalogues();

    // 获取所有分类中的第一页
    final futureResult = await Future.wait(catalogues.map((e) => service.queryAnnounceList(page, e.id)));

    // 合并所有分类的第一页的公告项
    final List<BulletinRecord> records = futureResult.fold(
      <BulletinRecord>[],
      (List<BulletinRecord> previousValue, BulletinListPage page) => previousValue + page.bulletinItems,
    ).toList();
    return records;
  }

  Widget _buildAnnounceList() {
    return PlaceholderFutureBuilder<List<BulletinRecord>>(
      futureGetter: () => _queryBulletinListInAllCategory(1),
      builder: (context, data, placeholder) {
        if (data == null) return placeholder;
        final records = data;

        // 公告项按时间排序
        records.sort((a, b) => b.dateTime.difference(a.dateTime).inSeconds);

        final items = records.map((e) => Card(child: _buildBulletinItem(context, e))).toList();
        return SingleChildScrollView(child: Column(children: items));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.ftype_oaAnnouncement.txt),
      body: _buildAnnounceList(),
    );
  }
}
