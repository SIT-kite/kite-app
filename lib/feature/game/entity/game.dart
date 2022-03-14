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

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../global/hive_type_id_pool.dart';

part 'game.g.dart';

@HiveType(typeId: HiveTypeIdPool.gameTypeItem)
enum GameType {
  /// 2048 游戏
  @HiveField(0)
  game2048,

  /// Wordle 游戏
  @HiveField(1)
  wordle,
}

int _getGameIndex(GameType type) => type.index;

@HiveType(typeId: HiveTypeIdPool.gameRecordItem)
@JsonSerializable()
class GameRecord {
  /// 游戏类型
  @HiveField(0)
  @JsonKey(name: 'game', toJson: _getGameIndex)
  final GameType type;

  /// 得分
  @HiveField(1)
  final int score;

  /// 游戏开始的时间
  @HiveField(2)
  @JsonKey(name: 'dateTime')
  final DateTime ts;

  /// 该局用时 （秒）
  @HiveField(3)
  final int timeCost;

  const GameRecord(this.type, this.score, this.ts, this.timeCost);

  Map<String, dynamic> toJson() => _$GameRecordToJson(this);
}

@JsonSerializable()
class GameRankingItem {
  /// 成绩值
  final int score;

  /// 学号
  final String studentId;

  const GameRankingItem(this.score, this.studentId);

  factory GameRankingItem.fromJson(Map<String, dynamic> json) => _$GameRankingItemFromJson(json);
}
