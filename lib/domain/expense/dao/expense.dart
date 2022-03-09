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
import 'package:kite/domain/expense/entity/expense.dart';

/// 远程的消费数据访问层的接口
abstract class ExpenseRemoteDao {
  /// 获取消费
  Future<OaExpensePage> getExpensePage(
    int pageNum, {
    required DateTime start,
    required DateTime end,
  });
}

/// 本地的消费数据访问接口
abstract class ExpenseLocalDao {
  /// 添加消费记录
  void add(ExpenseRecord record);

  /// 添加多条消费记录
  void addAll(Iterable<ExpenseRecord> records);

  /// 获取最近一次消费记录 (首页)
  ExpenseRecord? getLastOne();

  /// 清空消费记录存储
  void deleteAll();

  /// 获取所有消费记录
  List<ExpenseRecord> getAllByTimeDesc();

  /// 判断是否存在该记录
  bool isExist(DateTime ts);

  /// 判断本地存储是否为空
  bool isEmpty();
}
