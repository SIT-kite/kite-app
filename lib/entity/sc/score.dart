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

import 'dart:core';

class ScScoreSummary {
  /// Effective score
  final double effect;

  /// Total score
  final double total;

  /// Integrity score
  final double integrity;

  /// Subject report (主题报告)
  final double themeReport;

  /// Social practice (社会实践)
  final double socialPractice;

  /// Innovation, entrepreneurship and creativity.(创新创业创意)
  final double creativity;

  /// Campus safety and civilization.(校园安全文明)
  final double safetyCivilization;

  /// Charity and Volunteer.(公益志愿)
  final double charity;

  /// Campus culture.(校园文化)
  final double campusCulture;

  ScScoreSummary(this.effect, this.total, this.integrity, this.themeReport, this.socialPractice, this.creativity,
      this.safetyCivilization, this.charity, this.campusCulture);

  @override
  String toString() {
    return 'ScScoreSummary{effect: $effect, total: $total, integrity: $integrity, '
        'themeReport: $themeReport, socialPractice: $socialPractice, '
        'creativity: $creativity, safetyCivilization: $safetyCivilization, '
        'charity: $charity, campusCulture: $campusCulture}';
  }
}

class ScScoreItem {
  /// 活动编号
  final int activityId;

  /// 活动类型
  final int category;

  /// 分数
  final double amount;

  ScScoreItem(this.activityId, this.category, this.amount);

  @override
  String toString() {
    return 'ScScoreItem{activityId: $activityId, category: $category, '
        'amount: $amount}';
  }
}

class ScActivityItem {
  /// 活动编号
  final int activityId;

  /// 活动时间
  final DateTime time;

  /// 活动状态
  final String status;

  ScActivityItem(this.activityId, this.time, this.status);

  @override
  String toString() {
    return 'ScActivityItem{activityId: $activityId, time: $time, '
        'status: $status}';
  }
}
