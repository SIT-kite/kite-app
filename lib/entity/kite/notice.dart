import 'package:json_annotation/json_annotation.dart';

part 'notice.g.dart';

@JsonSerializable(createToJson: false)
class KiteNotice {
  /// 公告 ID
  final int id;

  /// 置顶
  final bool top;

  /// 标题
  final String title;

  /// 发布时间
  final DateTime publishTime;

  /// 公告正文
  final String? content;

  const KiteNotice(this.id, this.top, this.title, this.publishTime, this.content);

  factory KiteNotice.fromJson(Map<String, dynamic> json) => _$KiteNoticeFromJson(json);
}
