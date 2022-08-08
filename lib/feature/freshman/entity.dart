import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@JsonSerializable()
class FreshmanInfo {
  String name = '';
  int uid = 0;
  String studentId = '';
  String college = '';
  String major = '';
  String campus = '';
  String building = '';
  int room = 0;
  String bed = '';
  String counselorName = '';
  String counselorTel = '';
  bool visible = false;
  FreshmanInfo();
  factory FreshmanInfo.fromJson(Map<String, dynamic> json) =>
      _$FreshmanInfoFromJson(json);
}
