import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

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
  FreshmanInfo();
  factory FreshmanInfo.fromJson(Map<String, dynamic> json) => _$FreshmanInfoFromJson(json);

  @override
  String toString() {
    return 'FreshmanInfo{name: $name, uid: $uid, studentId: $studentId, college: $college, major: $major, campus: $campus, building: $building, room: $room, bed: $bed, counselorName: $counselorName, counselorTel: $counselorTel, visible: $visible}';
  }
}

@JsonSerializable()
class Contact {
  String? wechat;
  String? qq;
  String? phone;

  Contact();
  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);

  @override
  String toString() {
    return 'Contact{wechat: $wechat, qq: $qq, phone: $phone}';
  }
}

@JsonSerializable()
class Familiar {
  String name = '';
  String college = '';
  String gender = '';

  String? city;
  String? avatar;
  DateTime? lastSeen;
  Contact? contact;
  Familiar();
  factory Familiar.fromJson(Map<String, dynamic> json) => _$FamiliarFromJson(json);

  @override
  String toString() {
    return 'Familiar{name: $name, college: $college, gender: $gender, city: $city, avatar: $avatar, lastSeen: $lastSeen, contact: $contact}';
  }
}

@JsonSerializable()
class Mate {
  String college = '';
  String major = '';
  String name = '';
  String building = '';
  int room = 0;
  String bed = '';
  String gender = '';

  String? province;
  DateTime? lastSeen;
  String? avatar;
  Contact? contact;
  Mate();
  factory Mate.fromJson(Map<String, dynamic> json) => _$MateFromJson(json);

  @override
  String toString() {
    return 'Mate{college: $college, major: $major, name: $name, building: $building, room: $room, bed: $bed, gender: $gender, province: $province, lastSeen: $lastSeen, avatar: $avatar, contact: $contact}';
  }
}

@JsonSerializable()
class AnalysisMajor {
  int total = 0;
  int boys = 0;
  int girls = 0;

  AnalysisMajor();
  factory AnalysisMajor.fromJson(Map<String, dynamic> json) => _$AnalysisMajorFromJson(json);

  @override
  String toString() {
    return 'AnalysisMajor{total: $total, boys: $boys, girls: $girls}';
  }
}

@JsonSerializable()
class Analysis {
  int sameName = 0;
  int sameCity = 0;
  int sameHighSchool = 0;
  int collegeCount = 0;
  AnalysisMajor major = AnalysisMajor();
  Analysis();
  factory Analysis.fromJson(Map<String, dynamic> json) => _$AnalysisFromJson(json);

  @override
  String toString() {
    return 'Analysis{sameName: $sameName, sameCity: $sameCity, sameHighSchool: $sameHighSchool, collegeCount: $collegeCount, major: $major}';
  }
}
