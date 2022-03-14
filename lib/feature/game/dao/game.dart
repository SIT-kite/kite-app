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

import '../entity/game.dart';

/// 游戏记录访问接口
abstract class GameRecordStorageDao {
  /// 添加游戏记录
  void append(GameRecord record);

  /// 获取最近一次游戏记录 (首页)
  GameRecord? getLastOne();

  /// 清空游戏记录存储
  void deleteAll();

  /// 获取所有游戏成绩记录
  List<GameRecord> getAllRecords();
}

// 远程
abstract class RankingServiceDao {
  /// 获取游戏排名
  Future<List<GameRankingItem>> getGameRanking(int gameId);

  /// 上传用户成绩
  Future<void> postScore(GameRecord record);
}
