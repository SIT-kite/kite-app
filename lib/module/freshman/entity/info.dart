import 'package:json_annotation/json_annotation.dart';

part 'info.g.dart';

@JsonSerializable()
class FreshmanInfo {
  String name = '';
  int? uid;
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
  Contact? contact;

  FreshmanInfo();

  factory FreshmanInfo.fromJson(Map<String, dynamic> json) => _$FreshmanInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FreshmanInfoToJson(this);

  @override
  String toString() {
    return 'FreshmanInfo{name: $name, uid: $uid, studentId: $studentId, college: $college, major: $major, campus: $campus, building: $building, room: $room, bed: $bed, counselorName: $counselorName, counselorTel: $counselorTel, visible: $visible, yellow_pages: $contact}';
  }
}

@JsonSerializable()
class Contact {
  String? wechat;
  String? qq;
  String? tel;

  Contact();

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);

  @override
  String toString() {
    return 'Contact{wechat: $wechat, qq: $qq, tel: $tel}';
  }
}
