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
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kite/global/hive_type_id_pool.dart';

part 'entity.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeIdPool.reportHistoryItem)
class ReportHistory {
  /// 上报日期 "yyyyMMdd"
  @JsonKey(name: 'batchno')
  @HiveField(0)
  final int date;

  /// 当前所在位置 "省-市-区县"
  @JsonKey(name: 'position')
  @HiveField(1)
  final String place;

  /// 体温是否正常 （≤37.3℃）
  @JsonKey(name: 'wendu')
  @HiveField(2)
  final int isNormal;

  const ReportHistory(this.date, this.place, this.isNormal);

  factory ReportHistory.fromJson(Map<String, dynamic> json) => _$ReportHistoryFromJson(json);
}
