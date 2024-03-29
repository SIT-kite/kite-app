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

import '../dao/detail.dart';
import '../entity/detail.dart';
import '../using.dart';

class ScActivityDetailStorageBox with CachedBox {
  static const id2DetailKey = "/id2Detail";
  @override
  final Box<dynamic> box;
  late final id2Detail = Namespace<ActivityDetail, int>(id2DetailKey, makeId2Detail);

  String makeId2Detail(int activityId) => "$activityId";

  ScActivityDetailStorageBox(this.box);
}

class ScActivityDetailStorage extends ScActivityDetailDao {
  final ScActivityDetailStorageBox box;

  ScActivityDetailStorage(Box<dynamic> hive) : box = ScActivityDetailStorageBox(hive);

  @override
  Future<ActivityDetail?> getActivityDetail(int activityId) async {
    final cacheKey = box.id2Detail.make(activityId);
    return cacheKey.value;
  }

  void setActivityDetail(int activityId, ActivityDetail? detail) {
    final cacheKey = box.id2Detail.make(activityId);
    cacheKey.value = detail;
  }
}
