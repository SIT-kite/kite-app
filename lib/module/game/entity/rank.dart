import 'package:json_annotation/json_annotation.dart';
part 'rank.g.dart';
@JsonSerializable()
class GameRankingItem {
  /// 成绩值
  final int score;

  /// 学号
  final String studentId;

  const GameRankingItem(this.score, this.studentId);

  factory GameRankingItem.fromJson(Map<String, dynamic> json) => _$GameRankingItemFromJson(json);
}
