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

import '../dao/list.dart';
import '../entity/list.dart';
import '../using.dart';

class ScActivityListStorageBox with CachedBox {
  static const _activitiesNs = "/activities";
  @override
  final Box<dynamic> box;

  ScActivityListStorageBox(this.box);

  late final activities = ListNamespace<Activity>(_activitiesNs);
}

class ScActivityListStorage extends ScActivityListDao {
  final ScActivityListStorageBox box;

  static String makeActivityKey(ActivityType type, int page) {
    return "$type/$page";
  }

  ScActivityListStorage(Box<dynamic> hive) : box = ScActivityListStorageBox(hive);

  @override
  Future<List<Activity>?> getActivityList(ActivityType type, int page) async {
    final key = box.activities.make(makeActivityKey(type, page));
    return key.value;
  }

  void setActivityList(ActivityType type, int page, List<Activity>? activities) {
    final key = box.activities.make(makeActivityKey(type, page));
    key.value = activities;
  }

  @override
  Future<List<Activity>?> query(String queryString) {
    throw UnimplementedError("Storage won't save query.");
  }
}
