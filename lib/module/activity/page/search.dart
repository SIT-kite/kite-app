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
import 'package:kite/module/activity/using.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../init.dart';
import '../user_widgets/card.dart';

class SearchBar extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  Widget buildEventResult(List<Activity> activities) {
    return ListView.builder(
        itemCount: activities.length,
        itemBuilder: (ctx, i) {
          return ActivityCard(activities[i]).sized(width: 400, height: 200);
        });
  }

  Widget _buildSearch() {
    return PlaceholderFutureBuilder<List<Activity>?>(
      future: ScInit.scActivityListService.query(query),
      builder: (context, data, state) {
        if (data == null) {
          return Placeholders.loading();
        } else {
          return buildEventResult(data);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearch();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
