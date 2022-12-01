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
import 'package:flutter/material.dart';
import 'package:kite/module/activity/entity/list.dart';
import 'package:rettulf/rettulf.dart';
import '../using.dart';
import '../dao/score.dart';

import '../entity/score.dart';
import '../init.dart';
import 'detail.dart';
import '../user_widgets/summary.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<ScJoinedActivity>? joined;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildEventList(context),
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
    //return [buildSummaryCard(context), buildList(context)].listview().padSymmetric(h: 12);
    return buildList(context).padSymmetric(h: 12);
  }

  Widget buildJoinedActivity(BuildContext context, ScJoinedActivity rawActivity) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subtitleStyle = Theme.of(context).textTheme.bodyText2;

    final color = rawActivity.isPassed ? Colors.green : context.themeColor;
    final trailingStyle = Theme.of(context).textTheme.headline6?.copyWith(color: color);
    final activity = ActivityParser.parse(rawActivity);

    final tile = ListTile(
      title: Text(activity.realTitle, style: titleStyle, maxLines: 2, overflow: TextOverflow.clip)
          .hero(rawActivity.applyId),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${i18n.activityApplicationTime}: ${context.dateFullNum(rawActivity.time)}', style: subtitleStyle),
          Text('${i18n.activityApplicationID}: ${rawActivity.applyId}', style: subtitleStyle),
        ],
      ),
      trailing: Text(rawActivity.amount.abs() > 0.01 ? rawActivity.amount.toStringAsFixed(2) : rawActivity.status,
          style: trailingStyle),
      onTap: rawActivity.activityId != -1
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => DetailPage(activity, hero: rawActivity.applyId, hideApplyButton: true)),
              );
            }
          : null,
    );
    return Card(
      child: tile,
    );
  }

  Widget buildSummaryCard(BuildContext ctx) {
    return PlaceholderFutureBuilder<ScScoreSummary>(
      future: ScInit.scScoreService.getScScoreSummary(),
      builder: (context, summary, placeholder) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), child: buildSummeryCard(ctx, summary, placeholder));
      },
    );
  }

  Widget buildList(BuildContext ctx) {
    return PlaceholderFutureBuilder<List<ScJoinedActivity>>(
      future: getMyActivityListJoinScore(ScInit.scScoreService),
      builder: (context, eventList, placeholder) {
        if (eventList != null) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: eventList.length,
            itemBuilder: (ctx, index) => buildJoinedActivity(ctx, eventList[index]),
          );
        } else {
          return placeholder;
        }
      },
    );
  }

// Animation
  final _scrollController = ScrollController();

  Widget buildLiveList(BuildContext ctx) {
    return PlaceholderFutureBuilder<List<ScJoinedActivity>>(
      future: getMyActivityListJoinScore(ScInit.scScoreService),
      builder: (context, eventList, placeholder) {
        if (eventList != null) {
          return LiveList(
            controller: _scrollController,
            itemCount: eventList.length,
            showItemDuration: const Duration(milliseconds: 300),
            itemBuilder: (ctx, index, animation) => buildAnimatedJoinedActivity(ctx, eventList[index], animation),
          );
        } else {
          return placeholder;
        }
      },
    );
  }

  Widget buildAnimatedJoinedActivity(
    BuildContext ctx,
    ScJoinedActivity activity,
    Animation<double> animation,
  ) =>
      // For example wrap with fade transition
      FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        // And slide transition
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.3),
            end: Offset.zero,
          ).animate(animation),
          // Paste you Widget
          child: buildJoinedActivity(ctx, activity),
        ),
      );
}
