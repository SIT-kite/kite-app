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
  factory FreshmanInfo.fromJson(Map<String, dynamic> json) => _$FreshmanInfoFromJson(json);
}

@JsonSerializable()
class Contact {
  String? wechat;
  String? qq;
  String? phone;

  Contact();
  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

@JsonSerializable()
class Roommate {
  String college = '';
  String major = '';
  String name = '';
  String province = '';
  String bed = '';
  String lastSeen = '';
  String avatar = '';
  Contact contact = Contact();
  Roommate();
  factory Roommate.fromJson(Map<String, dynamic> json) => _$RoommateFromJson(json);
}

@JsonSerializable()
class Familiar {
  String name = '';
  String college = '';
  String city = '';
  String gender = '';
  String avatar = '';
  String lastSeen = '';
  Contact contact = Contact();
  Familiar();
  factory Familiar.fromJson(Map<String, dynamic> json) => _$FamiliarFromJson(json);
}

@JsonSerializable()
class Classmate {
  String college = '';
  String major = '';
  String name = '';
  String province = '';
  String building = '';
  String room = '';
  String bed = '';
  String gender = '';
  String lastSeen = '';
  String avatar = '';
  Contact contact = Contact();
  Classmate();
  factory Classmate.fromJson(Map<String, dynamic> json) => _$ClassmateFromJson(json);
}

@JsonSerializable()
class AnalysisMajor {
  int total = 0;
  int boys = 0;
  int girls = 0;

  AnalysisMajor();
  factory AnalysisMajor.fromJson(Map<String, dynamic> json) => _$AnalysisMajorFromJson(json);
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
}
