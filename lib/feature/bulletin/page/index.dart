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

import '../entity/bulletin.dart';
import '../init.dart';
import 'detail.dart';

class BulletinPage extends StatelessWidget {
  static final _dateFormat = DateFormat('yyyy/MM/dd hh:mm');

  const BulletinPage({Key? key}) : super(key: key);

  Widget _buildBulletinItem(BuildContext context, BulletinRecord record) {
    final titleStyle = Theme.of(context).textTheme.headline5;
    final subtitleStyle = Theme.of(context).textTheme.bodyText2;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(record.title, style: titleStyle, overflow: TextOverflow.ellipsis),
        subtitle: Text(record.department + ' | ' + _dateFormat.format(record.dateTime), style: subtitleStyle),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(record))),
      ),
    );
  }

  Future<List<BulletinRecord>> _queryBulletinListInAllCategory(int page) async {
    // Make sure login.
    await BulletinInitializer.session.get('https://myportal.sit.edu.cn/');

    final service = BulletinInitializer.bulletin;
    final catalogues = service.getAllCatalogues();
    final futureResult = await Future.wait(catalogues.map((e) => service.queryBulletinList(page, e.id)));

    final List<BulletinRecord> records = futureResult.fold(<BulletinRecord>[],
        (List<BulletinRecord> previousValue, BulletinListPage page) => previousValue + page.bulletinItems).toList();
    return records;
  }

  static void _sortBulletinRecord(List<BulletinRecord> recordList) {
    recordList.sort((a, b) {
      return b.dateTime.difference(a.dateTime).inSeconds;
    });
  }

  Widget _buildBulletinList() {
    final future = _queryBulletinListInAllCategory(1);

    return FutureBuilder<List<BulletinRecord>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final records = snapshot.data!;
              _sortBulletinRecord(records);

              final items = records.map((e) => _buildBulletinItem(context, e)).toList();
              return SingleChildScrollView(
                child: Column(
                  children: items,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('错误类型: ' + snapshot.error.runtimeType.toString()));
            }
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OA 公告'),
      ),
      body: _buildBulletinList(),
    );
  }
}
