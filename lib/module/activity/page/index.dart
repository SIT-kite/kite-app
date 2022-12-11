/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';
import 'package:kite/module/library/using.dart';

import '../using.dart';
import 'list.dart';
import 'mine.dart';
import 'search.dart';

class ActivityIndexPage extends StatefulWidget {
  const ActivityIndexPage({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityIndexPageState();
}

class _ActivityIndexPageState extends State<ActivityIndexPage> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveNavi(
      title: i18n.ftype_activity,
      defaultIndex: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => showSearch(context: context, delegate: SearchBar()),
        ),
      ],
      pages: [
        // Activity List page
        AdaptivePage(
          label: i18n.activityAllNavigation,
          unselectedIcon: const Icon(Icons.check_box_outline_blank),
          selectedIcon: const Icon(Icons.list_alt_rounded),
          builder: (ctx, key) {
            return ActivityListPage(key: key);
          },
        ),
        // Mine page
        AdaptivePage(
          label: i18n.activityMineNavigation,
          unselectedIcon: const Icon(Icons.person_outline_rounded),
          selectedIcon: const Icon(Icons.person_rounded),
          builder: (ctx, key) {
            return MyActivityPage(key: key);
          },
        ),
      ],
    );
  }
}
