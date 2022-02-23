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
import 'package:kite/entity/sc/list.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/sc/list.dart';

import 'card.dart';
import 'profile.dart';
import 'search.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with SingleTickerProviderStateMixin {
  static Map<ActivityType, String> categoryMapping = {
    ActivityType.lecture: '讲座报告',
    ActivityType.creation: '三创',
    ActivityType.theme: '主题教育',
    ActivityType.campus: '校园文化',
    ActivityType.practice: '社会实践',
    ActivityType.voluntary: '志愿公益',
  };

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: categoryMapping.length, vsync: this);
    super.initState();
  }

  TabBar _buildBarHeader() {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      tabs: categoryMapping.values.map((e) => Tab(text: e)).toList(),
    );
  }

  Widget _buildEventResult(List<Activity> activities) {
    return ListView(children: activities.map((e) => EventCard(e)).toList());
  }

  Widget _buildEventList(ActivityType type) {
    final future = ScActivityListService(SessionPool.scSession).getActivityList(type, 1);

    return FutureBuilder<List<Activity>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return _buildEventResult(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('活动'),
          bottom: _buildBarHeader(),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => showSearch(context: context, delegate: SearchBar()),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfilePage())),
            )
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: categoryMapping.keys.map((e) => _buildEventList(e)).toList(),
        ),
      ),
    );
  }
}
