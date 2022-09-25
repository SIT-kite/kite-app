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

enum ActivityType {
  lecture,
  theme,
  creation,
  campus,
  practice,
  voluntary,
  safetyEdu,
  unknown;

  String localized() {
    switch (this) {
      case lecture:
        return i18n.activityLecture;
      case theme:
        return i18n.activityThematicEdu;
      case creation:
        return i18n.activityCreation;
      case campus:
        return i18n.activitySchoolCulture;
      case practice:
        return i18n.activityPractice;
      case voluntary:
        return i18n.activityVoluntary;
      case safetyEdu:
        return i18n.activitySafetyEdu;
      case unknown:
        return i18n.activityUnknown;
    }
  }
}

enum ActivityScoreType {
  lecture,
  creation,
  campus,
  practice,
  voluntary,
  safetyEdu;
  // TODO: I18n
/*
  String toLocalized() {
    switch (this) {
      case lecture:
        return i18n.actLecture;
      case creation:
        return i18n.actCreation;
      case campus:
        return i18n.actSchoolCulture;
      case practice:
        return i18n.actPractice;
      case voluntary:
        return i18n.actVoluntary;
      case safetyEdu:
        return i18n.actSafetyEdu;
    }
  }*/
}

const Map<String, ActivityScoreType> stringToActivityScoreType = {
  '主题报告': ActivityScoreType.lecture,
  '社会实践': ActivityScoreType.practice,
  '创新创业创意': ActivityScoreType.creation,
  '校园文化': ActivityScoreType.campus,
  '公益志愿': ActivityScoreType.voluntary,
  '校园安全文明': ActivityScoreType.safetyEdu,
};

const Map<String, ActivityType> stringToActivityType = {
  '讲座报告': ActivityType.lecture,
  '主题教育': ActivityType.theme,
  '校园文化活动': ActivityType.campus,
  '创新创业创意': ActivityType.creation,
  '社会实践': ActivityType.practice,
  '志愿公益': ActivityType.voluntary,
  '安全教育网络教学': ActivityType.safetyEdu,
  '校园文明': ActivityType.campus,
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
