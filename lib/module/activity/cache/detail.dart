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
import '../storage/detail.dart';

class ScActivityDetailCache extends ScActivityDetailDao {
  final ScActivityDetailDao from;
  final ScActivityDetailStorage to;
  Duration expiration;

  ScActivityDetailCache({
    required this.from,
    required this.to,
    this.expiration = const Duration(minutes: 10),
  });

  @override
  Future<ActivityDetail?> getActivityDetail(int activityId) async {
    final cacheKey = to.box.id2Detail.make(activityId.toString());
    if (cacheKey.needRefresh(after: expiration)) {
      final res = await from.getActivityDetail(activityId);
      to.setActivityDetail(activityId, res);
      return res;
    } else {
      return to.getActivityDetail(activityId);
    }
  }
}
