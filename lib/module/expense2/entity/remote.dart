/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:json_annotation/json_annotation.dart';

part 'remote.g.dart';

/// The analysis of expense tracker is [here](https://github.com/SIT-kite/expense-tracker).
@JsonSerializable()
class DatapackRaw {
  DatapackRaw();
  int retcode = 0;
  int retcount = 0;
  List<TransactionRaw> retdata = [];
  String retmsg = "";
  factory DatapackRaw.fromJson(Map<String, dynamic> json) => _$DatapackRawFromJson(json);

  Map<String, dynamic> toJson() => _$DatapackRawToJson(this);
}

@JsonSerializable()
class TransactionRaw {
  TransactionRaw();

  /// example: "20221102"
  /// transaction data
  /// format: yyyymmdd
  String transdate = "";

  /// transaction time
  /// example: "114745"
  /// format: hhmmss
  String transtime = "";

  /// customer id
  /// example: 11045158
  int custid = 0;

  /// transaction flag
  int transflag = 0;

  /// card before balance
  /// example: 76.5
  double cardbefbal = 0;

  /// the amount of this transaction performed
  /// example: 70.5
  double cardaftbal = 0;

  /// card after balance
  /// example: 6
  double amount = 0;

  /// device name
  /// example: "奉贤一食堂一楼汇多pos4（新）", "多媒体-3-4号楼", "上海应用技术学院"
  String? devicename = "";

  /// transaction name
  /// example: "pos消费", "支付宝充值", "补助领取", "批量销户" or "卡冻结", "下发补助" or "补助撤销"
  String transname = "";

  factory TransactionRaw.fromJson(Map<String, dynamic> json) => _$TransactionRawFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionRawToJson(this);
}
