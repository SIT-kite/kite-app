import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/global/hive_type_id_pool.dart';

part 'report.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeIdPool.reportHistoryItem)
class ReportHistory {
  /// 上报日期, 格式如 20220118.
  @JsonKey(name: 'batchno')
  @HiveField(0)
  final int date;

  /// 当前所在位置 "省-市-区县"
  @JsonKey(name: 'position')
  @HiveField(1)
  final String place;

  /// 体温是否正常 （≤37.3℃）
  @JsonKey(name: 'wendu')
  @HiveField(2)
  final int isNormal;

  const ReportHistory(this.date, this.place, this.isNormal);

  factory ReportHistory.fromJson(Map<String, dynamic> json) => _$ReportHistoryFromJson(json);
}
