
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

  ScScoreSummary(this.effect, this.total, this.integrity,
      this.themeReport, this.socialPractice, this.creativity,
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
