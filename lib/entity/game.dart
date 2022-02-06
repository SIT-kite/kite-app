/*
 * 上应小风筝(SIT-kite)  便利校园，一步到位
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

import 'package:hive/hive.dart';

import '../global/hive_type_id_pool.dart';

part 'game.g.dart';

@HiveType(typeId: HiveTypeIdPool.gameTypeItem)
enum GameType {
  /// 2048 游戏
  @HiveField(0)
  game2048,
}

@HiveType(typeId: HiveTypeIdPool.gameRecordItem)
class GameRecord {
  /// 游戏类型
  @HiveField(0)
  final GameType type;

  /// 得分
  @HiveField(1)
  final int score;

  /// 游戏开始的时间
  @HiveField(2)
  final DateTime ts;

  /// 该局用时 （秒）
  @HiveField(3)
  final int timeCost;

  const GameRecord(this.type, this.score, this.ts, this.timeCost);
}
