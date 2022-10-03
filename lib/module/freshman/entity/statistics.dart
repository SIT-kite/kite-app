import 'package:json_annotation/json_annotation.dart';
part 'statistics.g.dart';

@JsonSerializable()
class AnalysisMajor {
  /// 同专业总人数
  int total = 0;

  /// 同专业的男生
  int boys = 0;

  /// 同专业的女生
  int girls = 0;

  AnalysisMajor();

  factory AnalysisMajor.fromJson(Map<String, dynamic> json) => _$AnalysisMajorFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisMajorToJson(this);

  @override
  String toString() {
    return 'AnalysisMajor{total: $total, boys: $boys, girls: $girls}';
  }
}

@JsonSerializable()
class Analysis {
  /// 同名人数
  int sameName = 0;

  /// 来自同一个城市的人数
  int sameCity = 0;

  /// 来自同一个高中的人数
  int sameHighSchool = 0;

  /// 学院人数
  int collegeCount = 0;

  /// 专业人数信息分析
  AnalysisMajor major = AnalysisMajor();

  Analysis();

  factory Analysis.fromJson(Map<String, dynamic> json) => _$AnalysisFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisToJson(this);

  @override
  String toString() {
    return 'Analysis{sameName: $sameName, sameCity: $sameCity, sameHighSchool: $sameHighSchool, collegeCount: $collegeCount, major: $major}';
  }
}
