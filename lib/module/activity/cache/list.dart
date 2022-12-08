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
import '../storage/list.dart';

class ScActivityListCache extends ScActivityListDao {
  final ScActivityListDao from;
  final ScActivityListStorage to;
  Duration expiration;

  ScActivityListCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  final Map<String, List<Activity>> _queried = {};

  @override
  Future<List<Activity>?> getActivityList(ActivityType type, int page) async {
    final cacheKey = to.box.activities.make(type, page);
    if (cacheKey.needRefresh(after: expiration)) {
      try {
        final res = await from.getActivityList(type, page);
        to.setActivityList(type, page, res);
        return res;
      } catch (e) {
        return to.getActivityList(type, page);
      }
    } else {
      return to.getActivityList(type, page);
    }
  }

  @override
  Future<List<Activity>?> query(String queryString) async {
    var res = _queried[queryString];
    res ??= await from.query(queryString);
    if (res != null) {
      _queried[queryString] = res;
    }
    return res;
  }
}
