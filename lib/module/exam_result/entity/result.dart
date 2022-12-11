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

import '../using.dart';

part 'result.g.dart';

/// REAL. THE PAYLOAD IS IN PINYIN. DONT BLAME ANYONE BUT THE SCHOOL.
/// More reading: https://github.com/sunnysab/zf-tools/blob/master/TRANSLATION.md
@JsonSerializable()
@HiveType(typeId: HiveTypeId.examResult)
class ExamResult {
  /// 成绩
  @JsonKey(name: 'cj', fromJson: stringToDouble)
  @HiveField(0)
  final double value;

  /// 课程
  @JsonKey(name: 'kcmc')
  @HiveField(1)
  final String course;

  /// 课程代码
  @JsonKey(name: 'kch')
  @HiveField(2)
  final String courseId;

  /// 班级（正方内部使用）
  @JsonKey(name: 'jxb_id')
  @HiveField(3)
  final String innerClassId;

  /// 班级ID（数字）
  @JsonKey(name: 'jxbmc', defaultValue: '无')
  @HiveField(4)
  final String dynClassId;

  /// 学年
  @JsonKey(name: 'xnmmc', fromJson: formFieldToSchoolYear, toJson: schoolYearToFormField)
  @HiveField(5)
  final SchoolYear schoolYear;

  /// 学期
  @JsonKey(name: 'xqm', fromJson: formFieldToSemester)
  @HiveField(6)
  final Semester semester;

  /// 学分
  @JsonKey(name: 'xf', fromJson: stringToDouble)
  @HiveField(7)
  final double credit;

  const ExamResult(this.value, this.course, this.courseId, this.innerClassId, this.schoolYear, this.semester,
      this.credit, this.dynClassId);

  factory ExamResult.fromJson(Map<String, dynamic> json) => _$ExamResultFromJson(json);

  @override
  String toString() {
    return 'Score{value: $value, course: $course, courseId: $courseId, innerClassId: $innerClassId, dynClassId: $dynClassId, schoolYear: $schoolYear, semester: $semester, credit: $credit}';
  }
}

@HiveType(typeId: HiveTypeId.examResultDetail)
class ExamResultDetail {
  /// 成绩名称
  @HiveField(0)
  final String scoreType;

  /// 占总成绩百分比
  @HiveField(1)
  final String percentage;

  /// 成绩数值
  @HiveField(3)
  final double value;

  const ExamResultDetail(
    this.scoreType,
    this.percentage,
    this.value,
  );
}
