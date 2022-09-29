/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:json_annotation/json_annotation.dart';

part 'evaluation.g.dart';
/// REAL. THE PAYLOAD IS IN PINYIN. DONT BLAME ANYONE BUT THE SCHOOL.
/// More reading: https://github.com/sunnysab/zf-tools/blob/master/TRANSLATION.md
@JsonSerializable()
class CourseToEvaluate {
  /// 老师姓名
  @JsonKey(name: 'jzgmc')
  final String teacher;

  /// 正方内部 HASH 过的老师编号
  @JsonKey(name: 'jgh_id')
  final String teacherId;

  /// 课程代码
  @JsonKey(name: 'kch_id')
  final String courseId;

  /// 课程名称
  @JsonKey(name: 'kcmc')
  final String courseName;

  /// 班级号（课程班级）
  @JsonKey(name: 'jxbmc')
  final String dynClassId;

  /// 正方内部的一个 HASH 过后的班级号
  @JsonKey(name: 'jxb_id')
  final String innerClassId;

  /// 评教编号
  @JsonKey(name: 'pjmbmcb_id', defaultValue: '')
  final String evaluationId;

  /// 评教状态
  @JsonKey(name: 'pjzt')
  final String evaluatingStatus;

  /// 提交状态
  @JsonKey(name: 'tjzt')
  final String submittingStatus;

  /// 学时代码. 课程中的理论和实践部分分开评教.
  @JsonKey(name: 'xsdm')
  final String subTypeId;
  @JsonKey(name: 'xsmc')
  final String subType;

  const CourseToEvaluate(this.teacher, this.courseId, this.courseName, this.dynClassId, this.evaluationId,
      this.teacherId, this.innerClassId, this.evaluatingStatus, this.submittingStatus, this.subTypeId, this.subType);

  factory CourseToEvaluate.fromJson(Map<String, dynamic> json) => _$CourseToEvaluateFromJson(json);
}
