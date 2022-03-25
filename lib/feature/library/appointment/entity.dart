import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@JsonSerializable(createToJson: false)
class Notice {
  DateTime ts;
  String html;

  Notice(this.ts, this.html);
  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
}

@JsonSerializable(createToJson: false)
class PeriodStatusRecord {
  /// 场次id
  int period;

  /// 总数
  int count;

  /// 已申请人数
  int applied;

  /// 场次描述
  String text;

  PeriodStatusRecord(this.period, this.count, this.applied, this.text);
  factory PeriodStatusRecord.fromJson(Map<String, dynamic> json) => _$PeriodStatusRecordFromJson(json);
}

@JsonSerializable(createToJson: false)
class ApplicationRecord {
  int id;
  int period;
  String user;
  int index;
  String text;
  int status;

  ApplicationRecord(this.id, this.period, this.user, this.index, this.text, this.status);
  factory ApplicationRecord.fromJson(Map<String, dynamic> json) => _$ApplicationRecordFromJson(json);
}

@JsonSerializable(createToJson: false)
class ApplyResponse {
  int id;
  String text;
  int index;

  ApplyResponse(this.id, this.text, this.index);
  factory ApplyResponse.fromJson(Map<String, dynamic> json) => _$ApplyResponseFromJson(json);
}
