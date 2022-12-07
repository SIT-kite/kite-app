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

import 'package:kite/module/activity/storage/score.dart';

import '../dao/score.dart';
import '../entity/score.dart';

class ScScoreCache extends ScScoreDao {
  final ScScoreDao from;
  final ScScoreStorage to;
  Duration expiration;

  ScScoreCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  @override
  Future<ScScoreSummary?> getScoreSummary() async {
    if (to.box.myScoreSummary.needRefresh(after: expiration)) {
      final res = await from.getScoreSummary();
      to.setScScoreSummary(res);
      return res;
    } else {
      return to.getScoreSummary();
    }
  }

  @override
  Future<List<ScScoreItem>> getMyScoreList() async {
    if (to.box.myScoreList.needRefresh(after: expiration)) {
      final res = await from.getMyScoreList();
      to.setMyScoreList(res);
      return res;
    } else {
      return to.getMyScoreList();
    }
  }

  @override
  Future<List<ScActivityApplication>> getMyInvolved() async {
    if (to.box.myInvolved.needRefresh(after: expiration)) {
      final res = await from.getMyInvolved();
      to.setMeInvolved(res);
      return res;
    } else {
      return to.getMyInvolved();
    }
  }
}
