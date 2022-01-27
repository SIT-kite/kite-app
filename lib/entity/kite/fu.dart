enum UploadResult {
  /// 无校徽
  noBadge,

  /// 达到最大限制
  maxLimit,

  /// 没抽中
  failed,

  /// 抽中
  successful,

  /// 活动结束
  outdated,
}

enum FuType {
  /// 无效卡片
  noCard,

  /// 爱国
  loveCountry,

  /// 富强
  wealthy,

  /// 和谐
  harmony,

  /// 友善
  friendly,

  /// 敬业
  dedicateToWork,
}

class UploadResultModel {
  /// 上传结果
  UploadResult result = UploadResult.noBadge;

  /// 福卡类型
  FuType type = FuType.noCard;
}

/// 我的卡片
class MyCard {
  FuType type = FuType.noCard;
  DateTime ts = DateTime.now();
}

/// 开奖信息
class PraiseResult {
  bool hasResult = false;
  String url = '';
}
