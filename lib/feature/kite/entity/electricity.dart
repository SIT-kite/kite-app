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

part 'electricity.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeIdPool.balanceItem)
class Balance {
  /// 余额
  @JsonKey()
  @HiveField(0)
  final double balance;

  /// 余量
  @JsonKey()
  @HiveField(1)
  final double power;

  /// 房间号
  @JsonKey()
  @HiveField(2)
  final int room;

  /// 更新时间
  @JsonKey()
  @HiveField(3)
  final DateTime ts;

  Balance(this.balance, this.power, this.room, this.ts);

  factory Balance.fromJson(Map<String, dynamic> json) => _$BalanceFromJson(json);
}

@JsonSerializable()
class Rank {
  /// 消费
  @JsonKey()
  final double consumption;

  /// 排名
  @JsonKey()
  final int rank;

  /// 房间总数
  @JsonKey()
  final int roomCount;

  Rank(this.consumption, this.rank, this.roomCount);

  factory Rank.fromJson(Map<String, dynamic> json) => _$RankFromJson(json);
}

@JsonSerializable()
class HourlyBill {
  /// 充值金额
  @JsonKey()
  final double charge;

  /// 消费金额
  @JsonKey()
  final double consumption;

  /// 时间
  @JsonKey()
  final DateTime time;

  HourlyBill(this.charge, this.consumption, this.time);

  factory HourlyBill.fromJson(Map<String, dynamic> json) => _$HourlyBillFromJson(json);
}

@JsonSerializable()
class DailyBill {
  /// 充值金额
  @JsonKey()
  final double charge;

  /// 消费金额
  @JsonKey()
  final double consumption;

  /// 时间
  @JsonKey()
  final DateTime date;

  DailyBill(this.charge, this.consumption, this.date);

  factory DailyBill.fromJson(Map<String, dynamic> json) => _$DailyBillFromJson(json);
}
