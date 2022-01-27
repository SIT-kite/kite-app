import 'package:json_annotation/json_annotation.dart';

part 'campus_card.g.dart';

@JsonSerializable()
class CardInfo {
  @JsonKey(name: 'DengLuMing') // 登录名
  final String studentId;
  @JsonKey(name: 'ZhenShiXingMing') // 正式姓名
  final String studentName;
  @JsonKey(name: 'ZuZhiJiGouName') // 组织机构Name（学院）
  final String major;

  const CardInfo(this.studentId, this.studentName, this.major);

  factory CardInfo.fromJson(Map<String, dynamic> json) => _$CardInfoFromJson(json);
// Map<String, dynamic> toJson() => _$CardInfoToJson(this);`
}
