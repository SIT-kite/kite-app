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

import 'package:flutter/material.dart' hide ThemeData;
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';
import 'list.dart';
import 'mine.dart';
import 'search.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ActivityPageState();
}

class _Page {
  static const list = 0;
  static const mine = 1;
}

class _ActivityPageState extends State<ActivityPage> with SingleTickerProviderStateMixin {
  /// For landscape mode.
  int curNavigation = _Page.list;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (ctx, orient) => orient == Orientation.portrait ? buildPortrait(ctx) : buildLandscape(ctx));
  }

  Widget buildPortrait(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: i18n.ftype_activity.text(), actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => showSearch(context: context, delegate: SearchBar()),
        ),
      ]),
      body: curNavigation == 0 ? const ActivityListPage() : const MyActivityPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: i18n.activityAllNavigation,
            icon: const Icon(Icons.list_alt_rounded),
          ),
          BottomNavigationBarItem(
            label: i18n.activityMineNavigation,
            icon: const Icon(Icons.person_rounded),
          )
        ],
        currentIndex: curNavigation,
        onTap: (int index) {
          setState(() => curNavigation = index);
        },
      ),
    );
  }

  Widget buildLandscape(BuildContext ctx) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.navigator.pop();
              },
            ),
            selectedIndex: curNavigation,
            groupAlignment: 1.0,
            onDestinationSelected: (int index) {
              setState(() {
                curNavigation = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: const Icon(Icons.check_box_outline_blank),
                selectedIcon: const Icon(Icons.list_alt_rounded),
                label: i18n.activityAllNavigation.text(),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.person_outline_rounded),
                selectedIcon: const Icon(Icons.person_rounded),
                label: i18n.activityMineNavigation.text(),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(child: curNavigation == _Page.list ? const ActivityListPage() : const MyActivityPage())
        ],
      ),
    );
  }
}
