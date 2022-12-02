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
import 'dao/score.dart';
import 'entity/score.dart';

Future<List<ScJoinedActivity>> getMyActivityListJoinScore(ScScoreDao scScoreDao) async {
  final activities = await scScoreDao.getMyActivityList();
  final scores = await scScoreDao.getMyScoreList();

  return activities.map((application) {
    // 对于每一次申请, 找到对应的加分信息
    final totalScore = scores
        .where((e) => e.activityId == application.activityId)
        .fold<double>(0.0, (double p, ScScoreItem e) => p + e.amount);
    // TODO: 潜在的 BUG，可能导致得分页面出现重复项。
    return ScJoinedActivity(application.applyId, application.activityId, application.title, application.time,
        application.status, totalScore);
  }).toList();
}
