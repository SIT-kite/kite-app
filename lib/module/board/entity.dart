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

part 'entity.g.dart';

@JsonSerializable()
class PictureSummary {
  /// Picture id.
  final String id;

  /// Publisher nickname
  final String publisher;

  /// Thumbnail image url.
  final String thumbnail;

  /// Origin picture url.
  final String origin;

  /// Publish time
  final String ts;

  const PictureSummary(this.id, this.publisher, this.thumbnail, this.origin, this.ts);

  factory PictureSummary.fromJson(Map<String, dynamic> json) => _$PictureSummaryFromJson(json);

  @override
  String toString() {
    return 'PictureSummary{id: $id, publisher: $publisher, thumbnail: $thumbnail, origin: $origin, ts: $ts}';
  }
}
