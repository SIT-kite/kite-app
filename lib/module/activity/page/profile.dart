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
import '../dao/score.dart';

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
        return Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), child: SummaryCard(summary));
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
      final color = activity.isPassed ? Colors.green : context.themeColor;
      final trailingStyle = Theme.of(context).textTheme.headline6?.copyWith(color: color);

      final tile = ListTile(
        title: Text(activity.title, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${i18n.activityApplicationTime}: ${context.dateFullNum(activity.time)}', style: subtitleStyle),
            Text('${i18n.activityApplicationID}: ${activity.applyId}', style: subtitleStyle),
          ],
        ),
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
      return Card(
        child: tile,
      );
    }

    return MyFutureBuilder<List<ScJoinedActivity>>(
      future: getMyActivityListJoinScore(ScInit.scScoreService),
      builder: (context, eventList) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child:
              ListView(children: [_buildSummaryCard(), const Divider()] + eventList.map(joinedActivityMapper).toList()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: i18n.activityMyApplication.txt),
      body: _buildEventList(context),
    );
  }
}
