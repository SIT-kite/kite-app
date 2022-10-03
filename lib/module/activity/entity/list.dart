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
import 'package:kite/l10n/extension.dart';

/// No I18n for unambiguity among all languages
class ActivityName {
  static const lectureReport = "讲座报告";
  static const thematicReport = "主题报告";
  static const creation = "三创";
  static const practice = "社会实践";
  static const safetyCiviEdu = "校园安全文明";
  static const cyberSafetyEdu = "安全教育网络教学";
  static const schoolCulture = "校园文化";
  static const thematicEdu = "主题教育";
  static const unknown = "未知";
  static const voluntary = "志愿公益";
  static const blackList = ["补录"];
}

enum ActivityType {
  lecture(ActivityName.lectureReport), // 讲座报告
  thematicEdu(ActivityName.thematicEdu), // 主题教育
  creation(ActivityName.creation), // 三创
  schoolCulture(ActivityName.schoolCulture), // 校园文化
  practice(ActivityName.practice), // 社会实践
  voluntary(ActivityName.voluntary), // 志愿公益
  cyberSafetyEdu(ActivityName.cyberSafetyEdu), // 安全教育网络教学
  unknown(ActivityName.unknown); // 未知

  final String name;

  const ActivityType(this.name);
}

enum ActivityScoreType {
  thematicReport(ActivityName.thematicReport), // 讲座报告
  creation(ActivityName.creation), // 三创
  schoolCulture(ActivityName.schoolCulture), // 校园文化
  practice(ActivityName.practice), // 社会实践
  voluntary(ActivityName.voluntary), // 志愿公益
  safetyCiviEdu(ActivityName.safetyCiviEdu); // 校园安全文明

  final String name;

  const ActivityScoreType(this.name);
}

/// Don't Change this.
/// Strings from school API
const Map<String, ActivityScoreType> stringToActivityScoreType = {
  '主题报告': ActivityScoreType.thematicReport,
  '社会实践': ActivityScoreType.practice,
  '创新创业创意': ActivityScoreType.creation, // 三创
  '校园文化': ActivityScoreType.schoolCulture,
  '公益志愿': ActivityScoreType.voluntary,
  '校园安全文明': ActivityScoreType.safetyCiviEdu,
};

/// Don't Change this.
/// Strings from school API
const Map<String, ActivityType> stringToActivityType = {
  '讲座报告': ActivityType.lecture,
  '主题教育': ActivityType.thematicEdu,
  '校园文化活动': ActivityType.schoolCulture,
  '创新创业创意': ActivityType.creation, // 三创
  '社会实践': ActivityType.practice,
  '志愿公益': ActivityType.voluntary,
  '安全教育网络教学': ActivityType.cyberSafetyEdu,
  '校园文明': ActivityType.schoolCulture,
};

class Activity {
  /// Activity id
  final int id;

  /// Activity category
  final ActivityType category;

  /// Title
  final String title;

  /// Date
  final DateTime ts;

  const Activity(this.id, this.category, this.title, this.ts);

  @override
  String toString() {
    return 'Activity{id: $id, category: $category}';
  }
}
