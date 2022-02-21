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

import 'card.dart';
import 'profile.dart';
import 'search.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  TabBar _buildBarHeader() {
    final tabs = ['讲座报告', '主题教育', '三创', '校园文化', '社会实践', '志愿公益'];
    return TabBar(isScrollable: true, tabs: tabs.map((e) => Tab(text: e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    final card = EventCard('这是活动标题', '大活', DateTime.now());

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('活动'),
          bottom: _buildBarHeader(),
          actions: [
            IconButton(
                icon: const Icon(Icons.search), onPressed: () => showSearch(context: context, delegate: SearchBar())),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfilePage())),
            )
          ],
        ),
        body: ListView(
          children: [card, card, card],
        ),
      ),
    );
  }
}
