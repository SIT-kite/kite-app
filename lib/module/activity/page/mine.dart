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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/module/activity/entity/list.dart';
import 'package:rettulf/rettulf.dart';
import '../using.dart';

import '../entity/score.dart';
import '../init.dart';
import '../utils.dart';
import 'detail.dart';
import '../user_widgets/summary.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  List<ScJoinedActivity>? joined;
  ScScoreSummary? summary;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildActivityList(context),
    );
  }

  void onRefresh() {
    ScInit.scScoreService.getScScoreSummary().then((value) {
      setState(() {
        summary = value;
      });
    });
    getMyActivityListJoinScore(ScInit.scScoreService).then((value) {
      setState(() {
        joined = value;
      });
    });
  }

  Widget _buildActivityList(BuildContext context) {
    final orient = MediaQuery.of(context).orientation;
    return [
      Align(
        alignment: Alignment.topCenter,
        child: buildSummeryCard(context, summary),
      ),
      buildLiveList(context)
    ].flex(direction: orient == Orientation.portrait ? Axis.vertical : Axis.horizontal);
  }

  Widget buildJoinedActivityCard(BuildContext context, ScJoinedActivity rawActivity) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subtitleStyle = Theme.of(context).textTheme.bodyText2;

    final color = rawActivity.isPassed ? Colors.green : context.themeColor;
    final trailingStyle = Theme.of(context).textTheme.headline6?.copyWith(color: color);
    final activity = ActivityParser.parse(rawActivity);

    return Card(
      child: ListTile(
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
      ),
    ).padSymmetric(h: 8);
  }

// Animation
  final _scrollController = ScrollController();

  Widget buildLiveList(BuildContext ctx) {
    final activities = joined;
    if (activities == null) {
      return Container();
    } else {
      /*     return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (ctx, index) => buildJoinedActivityCard(ctx, activities[index])).expended();
*/
      return ScrollConfiguration(
        behavior: const CupertinoScrollBehavior(),
        child: LiveList(
          controller: _scrollController,
          itemCount: activities.length,
          physics: const BouncingScrollPhysics(),
          showItemDuration: const Duration(milliseconds: 300),
          itemBuilder: (ctx, index, animation) => buildAnimatedJoinedActivity(ctx, activities[index], animation),
        ).expended(),
      );
    }
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
          child: buildJoinedActivityCard(ctx, activity),
        ),
      );
}
