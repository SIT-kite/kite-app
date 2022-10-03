import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/global/hive_type_id_pool.dart';
import 'package:kite/module/game/entity/type.dart';

part 'record.g.dart';

@HiveType(typeId: HiveTypeIdPool.gameRecordItem)
@JsonSerializable()
class GameRecord {
  /// 游戏类型
  @HiveField(0)
  @JsonKey(name: 'game', toJson: GameType.toIndex, fromJson: GameType.fromIndex)
  final GameType type;

  /// 得分
  @HiveField(1)
  final int score;

  /// 游戏开始的时间
  @HiveField(2)
  @JsonKey(name: 'dateTime')
  DateTime ts;

  /// 该局用时 （秒）
  @HiveField(3)
  final int timeCost;

  GameRecord(this.type, this.score, this.ts, this.timeCost);

  Map<String, dynamic> toJson() => _$GameRecordToJson(this);

  factory GameRecord.fromJson(Map<String, dynamic> json) => _$GameRecordFromJson(json);

  @override
  String toString() {
    return 'GameRecord{type: $type, score: $score, ts: $ts, timeCost: $timeCost}';
  }
}
