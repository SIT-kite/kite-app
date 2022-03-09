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
import 'package:kite/entity/sc/score.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/domain/sc/service/score.dart';

import 'component/summary.dart';
import 'detail.dart';

class ProfilePage extends StatelessWidget {
  final displayDateFormat = DateFormat('yyyy-MM-dd hh:mm');
  final ScScoreService service = ScScoreService(SessionPool.scSession);

  ProfilePage({Key? key}) : super(key: key);

  Widget _buildSummaryCard() {
    return MyFutureBuilder<ScScoreSummary>(
      future: service.getScScoreSummary(),
      builder: (context, summary) {
        return Padding(padding: const EdgeInsets.all(20), child: SummaryCard(summary));
      },
    );
  }

  Widget _buildEventList(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline5;
    final subtitleStyle = Theme.of(context).textTheme.bodyText2;
    TextStyle? trailingStyle = Theme.of(context).textTheme.headline5;

    Widget joinedActivityMapper(ScJoinedActivity activity) {
      final color = activity.status == '通过' ? Colors.green : Theme.of(context).primaryColor;
      trailingStyle = trailingStyle?.copyWith(color: color);

      return ListTile(
        title: Text(activity.title, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
            '申请时间: ${displayDateFormat.format(activity.time)}\n'
            '申请编号: ${activity.applyId}',
            style: subtitleStyle),
        trailing:
            Text(activity.amount.abs() > 0.01 ? activity.amount.toString() : activity.status, style: trailingStyle),
        onTap: activity.activityId != -1
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => DetailPage(activity.activityId, hideApplyButton: true)),
                );
              }
            : null,
      );
    }

    return MyFutureBuilder<List<ScJoinedActivity>>(
      future: service.getMyActivityListJoinScore(),
      builder: (context, eventList) {
        return ListView(children: [_buildSummaryCard()] + eventList.map(joinedActivityMapper).toList());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的第二课堂')),
      body: _buildEventList(context),
    );
  }
}
