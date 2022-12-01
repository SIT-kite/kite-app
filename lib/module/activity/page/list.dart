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
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../init.dart';
import '../using.dart';
import '../user_widgets/card.dart';
import 'profile.dart';
import 'search.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> with SingleTickerProviderStateMixin {
  static const categories = [
    ActivityType.lecture,
    ActivityType.creation,
    ActivityType.thematicEdu,
    ActivityType.schoolCulture,
    ActivityType.practice,
    ActivityType.voluntary,
  ];

  late TabController _tabController;

  final pageChangeNotifier = ValueNotifier(0);
  bool init = false;

  @override
  void initState() {
    _tabController = TabController(
      length: categories.length,
      vsync: this,
    );
    _tabController.addListener(() => pageChangeNotifier.value = _tabController.index);
    super.initState();
  }

  TabBar _buildBarHeader(BuildContext ctx) {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      tabs: categories
          .map((e) => Tab(
        child: Text(e.name, style: Theme.of(ctx).textTheme.bodyLarge),
      ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: _buildBarHeader(context),
        body: TabBarView(
          controller: _tabController,
          children: categories.map((selectedActivityType) {
            return ValueListenableBuilder(
              valueListenable: pageChangeNotifier,
              builder: (context, index, child) {
                return ActivityList(selectedActivityType);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ActivityList extends StatefulWidget {
  final ActivityType type;

  const ActivityList(this.type, {super.key});

  @override
  State<StatefulWidget> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  int _lastPage = 1;
  bool _atEnd = false;
  List<Activity> _activityList = [];

  bool loading = true;

  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!_atEnd) {
          loadMoreActivities();
        }
      } else {
        setState(() {
          _atEnd = false;
        });
      }
    });
    loadInitialActivities();
    super.initState();
  }

  void loadInitialActivities() async {
    _lastPage = 1;
    _activityList = await ScInit.scActivityListService.getActivityList(widget.type, 1);
    _lastPage++;
    loading = false;
    if (!mounted) return;
    setState(() {});
  }

  void loadMoreActivities() async {
    if (_atEnd) return;

    final lastActivities = await ScInit.scActivityListService.getActivityList(widget.type, _lastPage);

    if (!mounted) return;
    if (lastActivities.isEmpty) {
      setState(() => _atEnd = true);
      return;
    }

    _lastPage++;
    setState(() => _activityList.addAll(lastActivities));
  }

  Widget buildAnimatedActivityCard(
      BuildContext context,
      Activity activity,
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
      child: ActivityCard(activity),
    ),
  );

  Widget _buildActivityResult(List<Activity> activities) {
    return LiveList(
      controller: _scrollController,
      itemCount: activities.length,
      showItemDuration: const Duration(milliseconds: 300),
      itemBuilder: (ctx, index, animation) => buildAnimatedActivityCard(ctx, activities[index], animation),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const SizedBox();
    return _buildActivityResult(_activityList);
  }
}
