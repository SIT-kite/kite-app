class ScoreDetail {
  /// 成绩名称
  final String scoreType;

  /// 占总成绩百分比
  final String percentage;

  /// 成绩数值
  final double value;

  const ScoreDetail({
    this.scoreType = "",
    this.percentage = "",
    this.value = 0.0,
  });
}
