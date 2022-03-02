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
import 'package:kite/entity/sc/score.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/sc/score.dart';

import 'component/summary.dart';

class ProfilePage extends StatelessWidget {
  final ScScoreService service = ScScoreService(SessionPool.scSession);

  ProfilePage({Key? key}) : super(key: key);

  Widget _buildSummaryCard() {
    return MyFutureBuilder<ScScoreSummary>(
      future: service.getScScoreSummary(),
      builder: (context, summary) {
        return Padding(padding: const EdgeInsets.all(20), child: SummaryCard(summary));
      },
    );
  }

  Widget _buildEventList() {
    Widget joinedActivityMapper(ScJoinedActivity activity) {
      return ListTile(title: Text(activity.title));
    }

    return MyFutureBuilder<List<ScJoinedActivity>>(
      future: service.getMyActivityListJoinScore(),
      builder: (context, eventList) {
        return ListView(children: eventList.map(joinedActivityMapper).toList());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的第二课堂')),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }
}
