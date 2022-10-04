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

import '../dao/index.dart';
import '../entity/score.dart';
import '../init.dart';
import 'detail.dart';
import 'summary.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Widget _buildSummaryCard() {
    return MyFutureBuilder<ScScoreSummary>(
      future: ScInit.scScoreService.getScScoreSummary(),
      builder: (context, summary) {
        return Padding(padding: const EdgeInsets.all(20), child: SummaryCard(summary));
      },
    );
  }

  Future<List<ScJoinedActivity>> getMyActivityListJoinScore(ScScoreDao scScoreDao) async {
    final activities = await scScoreDao.getMyActivityList();
    final scores = await scScoreDao.getMyScoreList();

    return activities.map((application) {
      // 对于每一次申请, 找到对应的加分信息
      final totalScore = scores
          .where((e) => e.activityId == application.activityId)
          .fold<double>(0.0, (double p, ScScoreItem e) => p + e.amount);
      // TODO: 潜在的 BUG，可能导致得分页面出现重复项。
      return ScJoinedActivity(application.applyId, application.activityId, application.title, application.time,
          application.status, totalScore);
    }).toList();
  }

  Widget _buildEventList(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subtitleStyle = Theme.of(context).textTheme.bodyText2;

    Widget joinedActivityMapper(ScJoinedActivity activity) {
      final color = activity.status == '通过' ? Colors.green : Theme.of(context).primaryColor;
      final trailingStyle = Theme.of(context).textTheme.headline6?.copyWith(color: color);

      return ListTile(
        title: Text(activity.title, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
            '申请时间: ${context.dateFullNum(activity.time)}\n'
            '申请编号: ${activity.applyId}',
            style: subtitleStyle),
        trailing: Text(activity.amount.abs() > 0.01 ? activity.amount.toStringAsFixed(2) : activity.status,
            style: trailingStyle),
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
      future: getMyActivityListJoinScore(ScInit.scScoreService),
      builder: (context, eventList) {
        return ListView(children: [_buildSummaryCard()] + eventList.map(joinedActivityMapper).toList());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.ftype_activity.txt),
      body: _buildEventList(context),
    );
  }
}
