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
import 'package:kite/global/hive_type_id_pool.dart';

part 'expense.g.dart';

/// 消费类型
@HiveType(typeId: HiveTypeIdPool.expenseTypeItem)
enum ExpenseType {
  /// 食堂
  @HiveField(0)
  canteen,

  /// 大活咖啡吧
  @HiveField(1)
  coffee,

  /// 热水
  @HiveField(2)
  water,

  /// 洗澡
  @HiveField(3)
  shower,

  /// 超市
  @HiveField(4)
  store,

  /// 未知
  @HiveField(5)
  unknown,

  /// 全部. (用于消费展示页)
  all,
}

/// 消费记录
@HiveType(typeId: HiveTypeIdPool.expenseItem)
class ExpenseRecord extends HiveObject {
  /// 学号
  @HiveField(0)
  String username = '';

  /// 姓名
  @HiveField(1)
  String name = '';

  /// 消费地点
  @HiveField(2)
  String place = '';

  /// 消费时间
  @HiveField(3)
  DateTime ts = DateTime.now();

  /// 消费金额
  @HiveField(4)
  double amount = 0.0;

  /// 消费类型
  @HiveField(5)
  ExpenseType type = ExpenseType.unknown;

  @override
  String toString() {
    return 'ExpenseRecord{username: $username, name: $name, place: $place, ts: $ts, amount: $amount, type: ${expenseTypeMapping[type]}}';
  }
}

/// 消费类型枚举与文字的映射表
const expenseTypeMapping = {
  ExpenseType.all: '全部',
  ExpenseType.canteen: '食堂',
  ExpenseType.coffee: '咖啡吧',
  ExpenseType.water: '开水',
  ExpenseType.shower: '洗浴',
  ExpenseType.store: '商店',
  ExpenseType.unknown: '其他',
};

/// 爬虫获得的消费页
class ExpensePage {
  /// 当前页号
  int currentPage = 1;

  /// 总页数
  int total = 10;

  /// 该页的记录数
  List<ExpenseRecord> records = [];

  @override
  String toString() {
    return 'ExpensePage{currentPage: $currentPage, total: $total, records: $records}';
  }
}
