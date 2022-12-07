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
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import '../using.dart';

import '../entity/announce.dart';
import '../entity/page.dart';
import '../init.dart';
import 'detail.dart';

class OaAnnouncePage extends StatefulWidget {
  const OaAnnouncePage({Key? key}) : super(key: key);

  @override
  State<OaAnnouncePage> createState() => _OaAnnouncePageState();
}

class _OaAnnouncePageState extends State<OaAnnouncePage> {
  List<AnnounceRecord>? _records;

  @override
  void initState() {
    super.initState();
    _queryBulletinListInAllCategory(1).then((value) {
      if (!mounted) return;
      setState(() {
        // 公告项按时间排序
        value.sort((a, b) => b.dateTime.difference(a.dateTime).inSeconds);
        _records = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.ftype_oaAnnouncement.text()),
      body: _buildAnnounceList(),
    );
  }

  Future<List<AnnounceRecord>> _queryBulletinListInAllCategory(int page) async {
    // Make sure login.
    await OaAnnounceInit.session.request('https://myportal.sit.edu.cn/', ReqMethod.get);

    final service = OaAnnounceInit.service;

    // 获取所有分类
    final catalogues = await service.getAllCatalogues();

    // 获取所有分类中的第一页
    final futureResult = await Future.wait(catalogues.map((e) => service.queryAnnounceList(page, e.id)));
    // 合并所有分类的第一页的公告项
    final List<AnnounceRecord> records = futureResult.whereNotNull().fold(
      <AnnounceRecord>[],
      (List<AnnounceRecord> previousValue, AnnounceListPage page) => previousValue + page.bulletinItems,
    ).toList();
    return records;
  }

  Widget _buildAnnounceList() {
    final records = _records;
    if (records == null) return Placeholders.loading();

    return _buildAnnounceLiveGrid(records);
  }

  Widget _buildAnnounceLiveGrid(List<AnnounceRecord> records) {
    final items = records.mapIndexed((i, e) => _buildAnnounceItem(context, e).inCard()).toList();
    return LayoutBuilder(builder: (ctx, constraints) {
      final count = constraints.maxWidth ~/ 300;
      return LiveGrid.options(
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
          childAspectRatio: 4,
        ),
        options: kiteLiveOptions,
        itemBuilder: (ctx, index, animation) => items[index].aliveWith(animation),
      );
    });
  }

  Widget _buildAnnounceItem(BuildContext context, AnnounceRecord record) {
    final titleStyle = Theme.of(context).textTheme.headline4;
    final subtitleStyle = Theme.of(context).textTheme.bodyText1;

    return ListTile(
      title: Text(record.title, style: titleStyle, overflow: TextOverflow.ellipsis).hero(record.uuid),
      subtitle: Text('${record.department} | ${context.dateNum(record.dateTime)}',
          style: subtitleStyle, overflow: TextOverflow.ellipsis),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailPage(
                record,
              ))),
    ).padAll(2);
  }
}
