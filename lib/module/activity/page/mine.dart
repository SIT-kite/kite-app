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
import 'package:kite/module/library/using.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/score.dart';
import '../init.dart';
import '../user_widgets/summary.dart';
import '../using.dart';
import '../utils.dart';
import 'detail.dart';

class MyActivityPage extends StatefulWidget {
  const MyActivityPage({super.key});

  @override
  State<MyActivityPage> createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> with AutomaticKeepAliveClientMixin, Navigatable {
  List<ScJoinedActivity>? joined;
  ScScoreSummary? summary;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: context.orientation == Orientation.portrait ? buildPortrait(context) : buildLandscape(context),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void onRefresh() {
    ScInit.scScoreService.getScoreSummary().then((value) {
      if (summary != value) {
        summary = value;
        if (!mounted) return;
        setState(() {
          navigatorKey = GlobalKey();
        });
      }
    });
    getMyActivityListJoinScore(ScInit.scScoreService).then((value) {
      if (joined != value) {
        joined = value;
        if (!mounted) return;
        setState(() {
          navigatorKey = GlobalKey();
        });
      }
    });
  }

  ScScoreSummary getTargetScore() {
    final admissionYear = int.tryParse(Auth.oaCredential?.account.substring(0, 2) ?? "") ?? 2000;
    return calcTargetScore(admissionYear);
  }

  Widget buildPortrait(BuildContext context) {
    final targetScore = getTargetScore();
    return [
      Align(
        alignment: Alignment.topCenter,
        child: buildSummeryCard(context, targetScore, summary),
      ),
      buildLiveList(context).expanded()
    ].column();
  }

  Widget buildLandscape(BuildContext ctx) {
    final targetScore = getTargetScore();
    return AdaptiveNavigation(ctx,
        child: [buildSummeryCard(ctx, targetScore, summary).expanded(), buildLiveList(context).expanded()].row());
    //return [buildSummeryCard(ctx, summary).expanded(), buildLiveList(context).expanded()].row();
  }

  Widget buildJoinedActivityCard(BuildContext context, ScJoinedActivity rawActivity) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subtitleStyle = Theme.of(context).textTheme.bodyText2;

    final color = rawActivity.isPassed ? Colors.green : context.themeColor;
    final trailingStyle = Theme.of(context).textTheme.headline6?.copyWith(color: color);
    final activity = ActivityParser.parse(rawActivity);

    return ListTile(
      title: Text(activity.realTitle, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
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
                MaterialPageRoute(builder: (_) => DetailPage(activity, hero: rawActivity.applyId, enableApply: false)),
              );
            }
          : null,
    ).inCard().hero(rawActivity.applyId).padSymmetric(h: 8);
  }

// Animation
  final _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget buildLiveList(BuildContext ctx) {
    final activities = joined;
    if (activities == null) {
      return Placeholders.loading();
    } else {
      return ScrollConfiguration(
        behavior: const CupertinoScrollBehavior(),
        child: LiveList(
          controller: _scrollController,
          itemCount: activities.length,
          physics: const BouncingScrollPhysics(),
          showItemInterval: const Duration(milliseconds: 40),
          itemBuilder: (ctx, index, animation) => buildJoinedActivityCard(ctx, activities[index]).aliveWith(animation),
        ),
      );
    }
  }
}
