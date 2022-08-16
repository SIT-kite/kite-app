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

@JsonSerializable(createToJson: false)
class Notice {
  DateTime ts;
  String html;

  Notice(this.ts, this.html);

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);

  @override
  String toString() {
    return 'Notice{ts: $ts, html: $html}';
  }
}

@JsonSerializable(createToJson: false)
class PeriodStatusRecord {
  /// 场次id
  int period;

  /// 总数
  int count;

  /// 已申请人数
  int applied;

  /// 场次描述
  String text;

  /// 是否已预约
  bool appointed;

  PeriodStatusRecord(this.period, this.count, this.applied, this.text, this.appointed);

  factory PeriodStatusRecord.fromJson(Map<String, dynamic> json) => _$PeriodStatusRecordFromJson(json);

  @override
  String toString() {
    return 'PeriodStatusRecord{period: $period, count: $count, applied: $applied, text: $text, appointed: $appointed}';
  }
}

@JsonSerializable(createToJson: false)
class ApplicationRecord {
  int id;
  int period;
  String user;
  int index;
  @JsonKey(defaultValue: '')
  String text;
  int status;

  ApplicationRecord(this.id, this.period, this.user, this.index, this.text, this.status);

  factory ApplicationRecord.fromJson(Map<String, dynamic> json) => _$ApplicationRecordFromJson(json);

  @override
  String toString() {
    return 'ApplicationRecord{id: $id, period: $period, user: $user, index: $index, text: $text, status: $status}';
  }
}

@JsonSerializable(createToJson: false)
class ApplyResponse {
  int id;
  String text;
  int index;

  ApplyResponse(this.id, this.text, this.index);

  factory ApplyResponse.fromJson(Map<String, dynamic> json) => _$ApplyResponseFromJson(json);

  @override
  String toString() {
    return 'ApplyResponse{id: $id, text: $text, index: $index}';
  }
}

@JsonSerializable(createToJson: false)
class CurrentPeriodResponse {
  DateTime? after;
  DateTime? before;
  int? period;
  int? next;

  CurrentPeriodResponse(this.after, this.before, this.period);

  factory CurrentPeriodResponse.fromJson(Map<String, dynamic> json) => _$CurrentPeriodResponseFromJson(json);

  @override
  String toString() {
    return 'CurrentPeriodResponse{after: $after, before: $before, period: $period, next: $next}';
  }
}
