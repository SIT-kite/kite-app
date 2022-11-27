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
import '../../user_widget/common.dart';
import '../../using.dart';

import 'classmate.dart';
import 'familiar.dart';

import 'roommate.dart';

class FreshmanRelationshipPage extends StatefulWidget {
  const FreshmanRelationshipPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FreshmanRelationshipPageState();
}

class _FreshmanRelationshipPageState extends State<FreshmanRelationshipPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  TabBar _buildBarHeader(BuildContext ctx) {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      tabs: [
        Tab(
            child: Text(
          i18n.roommate,
          style: Theme.of(ctx).textTheme.bodyLarge,
        )),
        Tab(
            child: Text(
          i18n.classmate,
          style: Theme.of(ctx).textTheme.bodyLarge,
        )),
        Tab(
            child: Text(
          i18n.friendsRadder,
          style: Theme.of(ctx).textTheme.bodyLarge,
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: i18n.newFriendsTitle.txt,
          bottom: _buildBarHeader(context),
          actions: buildAppBarMenuButton(context),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            RoommatePage(),
            ClassmatePage(),
            FamiliarPeoplePage(),
          ],
        ),
      ),
    );
  }
}
