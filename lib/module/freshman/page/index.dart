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
import 'package:kite/util/dsl.dart';

import '../user_widget/common.dart';
import 'classmate.dart';
import 'familiar.dart';
import 'package:kite/l10n/extension.dart';

import 'roommate.dart';

class FreshmanFriendPage extends StatefulWidget {
  const FreshmanFriendPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FreshmanFriendPageState();
}

class _FreshmanFriendPageState extends State<FreshmanFriendPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  TabBar _buildBarHeader() {
    return TabBar(
      isScrollable: true,
      controller: _tabController,
      tabs: [Tab(text: i18n.roommate), Text(i18n.classmate), Text(i18n.friendsRadder)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: i18n.newFriendsTitle.txt,
          bottom: _buildBarHeader(),
          actions: buildAppBarMenuButton(context),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            RoommateWidget(),
            ClassmateWidget(),
            FamiliarPeopleWidget(),
          ],
        ),
      ),
    );
  }
}
