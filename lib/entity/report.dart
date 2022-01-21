import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable()
class ReportHistory {
  /// 上报日期, 格式如 20220118.
  @JsonKey(name: 'batchno')
  final int date;

  /// 当前所在位置 "省-市-区县"
  @JsonKey(name: 'position')
  final String place;

  /// 体温是否正常 （≤37.3℃）
  @JsonKey(name: 'wendu')
  final int isNormal;

  const ReportHistory(this.date, this.place, this.isNormal);

  factory ReportHistory.fromJson(Map<String, dynamic> json) => _$ReportHistoryFromJson(json);
}
