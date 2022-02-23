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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kite/entity/sc/list.dart';

import 'background.dart';
import 'detail.dart';
import 'util.dart';

class EventCard extends StatelessWidget {
  static final dateFormat = DateFormat('yyyy-MM-dd');

  final Activity activity;

  const EventCard(this.activity, {Key? key}) : super(key: key);

  Widget _buildTagRow(BuildContext context, List<String> tags) {
    final backgroundColor = Theme.of(context).primaryColor.withAlpha(128);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(4)),
      child: Text(tags.sublist(0, min(2, tags.length)).join('  ')),
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline2?.copyWith(color: Colors.white);
    final subtitleStyle = Theme.of(context).textTheme.headline5?.copyWith(color: Colors.grey);

    final titleList = extractTitle(activity.title);
    final title = titleList.last;

    titleList.removeLast();
    final tags = titleList;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(4),
            child: Text(title, style: titleStyle, maxLines: 1, overflow: TextOverflow.ellipsis)),
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTagRow(context, tags),
                Text(dateFormat.format(activity.ts), style: subtitleStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.8,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(activity)));
          },
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Stack(
              children: [
                // Background
                Background(),
                // Title
                _buildBasicInfo(context),
              ],
            ),
          ),
        ));
  }
}
