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

import 'package:kite/module/activity/dao/score.dart';

import '../entity/score.dart';
import '../using.dart';

class _Key {
  static const scScoreSummary = "/myScoreSummary";
  static const scoreList = "/myScoreList";
  static const meInvolved = "/myInvolved";
}

class ScScoreStorageBox with CachedBox {
  @override
  final Box<dynamic> box;

  ScScoreStorageBox(this.box);

  late final myScoreSummary = Named<ScScoreSummary>(_Key.scScoreSummary);
  late final myScoreList = NamedList<ScScoreItem>(_Key.scoreList);
  late final myInvolved = NamedList<ScActivityApplication>(_Key.meInvolved);
}

class ScScoreStorage extends ScScoreDao {
  final ScScoreStorageBox box;

  ScScoreStorage(Box<dynamic> hive) : box = ScScoreStorageBox(hive);

  @override
  Future<ScScoreSummary?> getScoreSummary() async {
    return box.myScoreSummary.value;
  }

  @override
  Future<List<ScScoreItem>?> getMyScoreList() async {
    return box.myScoreList.value;
  }

  @override
  Future<List<ScActivityApplication>?> getMyInvolved() async {
    return box.myInvolved.value;
  }

  void setMeInvolved(List<ScActivityApplication>? list) {
    box.myInvolved.value = list;
  }

  void setScScoreSummary(ScScoreSummary? summery) {
    box.myScoreSummary.value = summery;
  }

  void setMyScoreList(List<ScScoreItem>? list) {
    box.myScoreList.value = list;
  }
}
