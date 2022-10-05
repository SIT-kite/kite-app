/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
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
