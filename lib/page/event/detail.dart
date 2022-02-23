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
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:kite/entity/sc/detail.dart';
import 'package:kite/entity/sc/list.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/sc/detail.dart';

class DetailPage extends StatelessWidget {
  final Activity summary;

  const DetailPage(this.summary, {Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('活动详情'),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.open_in_browser))],
    );
  }

  Widget _buildBasicInfo(ActivityDetail detail) {
    buildRow(String key, String value) => TableRow(
          children: [
            Text(key),
            Text(value),
          ],
        );

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(3),
        },
        children: [
          buildRow('标题', detail.title),
          buildRow('活动编号', detail.id.toString()),
          buildRow('地点', detail.place.toString()),
          buildRow('负责人', detail.undertaker.toString()),
          buildRow('管理方', detail.manager.toString()),
          buildRow('联系方式', detail.contact.toString()),
          buildRow('开始时间', detail.startTime.toString()),
          buildRow('时长', detail.duration.toString()),
        ],
      ),
    );
  }

  Widget _buildArticle(String html) {
    return HtmlWidget(html);
  }

  Widget _buildDetail(ActivityDetail detail) {
    final List<Widget> items = [_buildBasicInfo(detail), _buildArticle(detail.description ?? '暂无信息')];
    return Column(children: items);
  }

  Widget _buildBody() {
    final future = ScActivityDetailService(SessionPool.scSession).getActivityDetail(summary.id);

    return FutureBuilder<ActivityDetail>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildDetail(snapshot.data!);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.person_add),
        label: const Text('报名'),
      ),
    );
  }
}
