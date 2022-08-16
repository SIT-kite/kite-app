import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@JsonSerializable()
class PictureSummary {
  /// Picture uuid.
  final String uuid;

  /// Publisher nickname
  final String publisher;

  /// Thumbnail image url.
  final String thumbnail;

  /// Publish time
  final String ts;

  const PictureSummary(this.uuid, this.publisher, this.thumbnail, this.ts);

  factory PictureSummary.fromJson(Map<String, dynamic> json) =>
      _$PictureSummaryFromJson(json);
}
