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

import '../entity/list.dart';
import '../init.dart';
import '../using.dart';
import '../user_widgets/card.dart';
import 'profile.dart';
import 'search.dart';

class EventList extends StatefulWidget {
  final ActivityType type;

  const EventList(this.type, {super.key});

  @override
  State<StatefulWidget> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
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

  Widget _buildEventResult(List<Activity> activities) {
    return ListView(
      controller: _scrollController,
      children: activities.map((e) => EventCard(e)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return _buildEventResult(_activityList);
  }
}

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with SingleTickerProviderStateMixin {
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
        appBar: AppBar(
          title: i18n.ftype_activity.txt,
          bottom: _buildBarHeader(context),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => showSearch(context: context, delegate: SearchBar()),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfilePage())),
            )
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: categories.map((selectedActivityType) {
            return ValueListenableBuilder(
              valueListenable: pageChangeNotifier,
              builder: (context, index, child) {
                return EventList(selectedActivityType);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
