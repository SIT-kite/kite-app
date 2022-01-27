import 'package:json_annotation/json_annotation.dart';

part 'fu.g.dart';

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

UploadResult _intToUploadResult(int foo) {
  return [
    null,
    UploadResult.noBadge,
    UploadResult.maxLimit,
    UploadResult.failed,
    UploadResult.successful,
    UploadResult.outdated,
  ][foo]!;
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

FuType _intToFuType(int foo) {
  return [
    FuType.noCard,
    FuType.loveCountry,
    FuType.wealthy,
    FuType.harmony,
    FuType.friendly,
    FuType.dedicateToWork,
  ][foo];
}

@JsonSerializable(createToJson: false)
class UploadResultModel {
  /// 上传结果
  @JsonKey(fromJson: _intToUploadResult)
  UploadResult result = UploadResult.noBadge;

  /// 福卡类型
  @JsonKey(fromJson: _intToFuType)
  FuType type = FuType.noCard;

  @override
  String toString() {
    return 'UploadResultModel{result: $result, type: $type}';
  }
}

/// 我的卡片
@JsonSerializable(createToJson: false)
class MyCard {
  @JsonKey(fromJson: _intToFuType)
  FuType type = FuType.noCard;
  DateTime ts = DateTime.now();

  @override
  String toString() {
    return 'MyCard{type: $type, ts: $ts}';
  }
}

/// 开奖信息
@JsonSerializable(createToJson: false)
class PraiseResult {
  bool hasResult = false;
  String url = '';

  @override
  String toString() {
    return 'PraiseResult{hasResult: $hasResult, url: $url}';
  }
}
