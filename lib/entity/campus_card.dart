import 'package:json_annotation/json_annotation.dart';

part 'campus_card.g.dart';

@JsonSerializable()
class CardInfo {
  @JsonKey(name: 'DengLuMing')
  final String studentId;
  @JsonKey(name: 'ZhenShiXingMing')
  final String studentName;
  @JsonKey(name: 'ZuZhiJiGouName')
  final String major;

  const CardInfo(this.studentId, this.studentName, this.major);

  factory CardInfo.fromJson(Map<String, dynamic> json) => _$CardInfoFromJson(json);
// Map<String, dynamic> toJson() => _$CardInfoToJson(this);`
}
