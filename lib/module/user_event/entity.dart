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
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'using.dart';
part 'entity.g.dart';

@HiveType(typeId: 10)
enum UserEventType {
  @HiveField(0)
  page,
  @HiveField(1)
  startup,
  @HiveField(2)
  exit,
  @HiveField(3)
  button,
}

/// 用户行为类
@HiveType(typeId: 11)
@JsonSerializable()
class UserEvent {
  /// 时间
  @HiveField(0)
  final DateTime ts;

  /// 类型
  @HiveField(1)
  @JsonKey(toJson: userEventTypeIndex)
  final UserEventType type;

  /// 参数
  @HiveField(2)
  final Map<String, dynamic> params;

  const UserEvent(this.ts, this.type, this.params);

  Map<String, dynamic> toJson() => _$UserEventToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

int userEventTypeIndex(UserEventType type) => type.index;
