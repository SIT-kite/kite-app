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
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/home/entity/home.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/util/dsl.dart';

import '../entity/list.dart';
import '../init.dart';
import 'component/card.dart';
import 'component/search.dart';
import 'profile.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with SingleTickerProviderStateMixin {
  static const categories = [
    ActivityType.lecture,
    ActivityType.creation,
    ActivityType.theme,
    ActivityType.campus,
    ActivityType.practice,
    ActivityType.voluntary,
  ];

  late TabController _tabController;

  final pageChangeNotifier = ValueNotifier(0);

  @override
  void initState() {
    _tabController = TabController(
      length: categories.length,
      vsync: this,
    );
    _tabController.addListener(() => pageChangeNotifier.value = _tabController.index);
    super.initState();
  }

  static bool _filterActivity(Activity activity) {
    const List<String> blackList = ['补录'];
    return !blackList.any((element) => activity.title.contains(element));
  }

  TabBar _buildBarHeader() {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      tabs: categories.map((e) => Tab(text: e.localized())).toList(),
    );
  }

  Widget _buildEventResult(List<Activity> activities) {
    return ListView(
      controller: ScrollController(),
      children: activities.map((e) => EventCard(e)).toList(),
    );
  }

  Widget _buildEventList(ActivityType type) {
    return MyFutureBuilder<List<Activity>>(
      future: ScInitializer.scActivityListService.getActivityList(type, 1),
      builder: (context, data) {
        final result = data.where(_filterActivity).toList();
        return _buildEventResult(result);
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: categories.map((e) {
        return ValueListenableBuilder(
          valueListenable: pageChangeNotifier,
          builder: (a, b, c) {
            return _buildEventList(e);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: FunctionType.event.localized().txt,
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
        body: _buildBody(context),
      ),
    );
  }
}
