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
import 'package:hive/hive.dart';
import 'package:kite/module/expense2/entity/local.dart';

class ExpenseStorageKeys {
  static const _namespace = '/expense';
  static const transactionTsList = '$_namespace/transactionIdList';
  static String buildTransactionsKeyByTs(DateTime ts) {
    final id = (ts.millisecondsSinceEpoch ~/ 1000).toRadixString(16);
    return '/expense/transactions/$id';
  }

  static const cachedTsStart = '/expense/cachedTsRange/start';
  static const cachedTsEnd = '/expense/cachedTsRange/end';
}

class ExpenseStorage {
  final Box box;
  ExpenseStorage(this.box);

  /// 清空所有交易记录
  void clear() => box.clear();

  /// 合并若干交易记录
  void merge({
    required Iterable<Transaction> records,
    required DateTime start,
    required DateTime end,
  }) {
    // 需要实现records中的时间与transactionTsList中的时间的合并并保证合并后有序
    final result = {...records.map((e) => e.datetime), ...transactionTsList}.toList();
    result.sort((a, b) => a.compareTo(b));
    box.put(ExpenseStorageKeys.transactionTsList, result);
    // 空集赋值
    cachedTsStart ??= start;
    cachedTsEnd ??= end;
    // start 比 cachedTsStart 还靠前
    if (start.isBefore(cachedTsStart!)) cachedTsStart = start;
    // end 比 cachedTsEnd 还靠后
    if (end.isAfter(cachedTsEnd!)) cachedTsEnd = end;

    for (final record in records) {
      box.put(ExpenseStorageKeys.buildTransactionsKeyByTs(record.datetime), record.toJson());
    }
  }

  /// 所有交易记录的索引，记录所有的交易时间，需要保证有序，以实现二分查找
  List<DateTime> get transactionTsList {
    final v = box.get(ExpenseStorageKeys.transactionTsList);
    if (v == null) return [];
    return List.unmodifiable(v);
  }

  /// 通过一个时间范围[start, end]来获得交易记录
  List<DateTime> getTransactionTsByRange({
    DateTime? start,
    DateTime? end,
  }) {
    return transactionTsList
        .where((e) => start == null || e == start || e.isAfter(start))
        .where((e) => end == null || e == end || e.isBefore(end))
        .toList();
  }

  /// 通过某个时刻来获得交易记录
  Transaction? getTransactionByTs(DateTime ts) {
    final json = box.get(ExpenseStorageKeys.buildTransactionsKeyByTs(ts));
    if (json == null) return null;
    return Transaction.fromJson((json as Map).cast<String, dynamic>());
  }

  /// 获取已缓存的交易起始时间
  DateTime? get cachedTsStart => box.get(ExpenseStorageKeys.cachedTsStart);
  set cachedTsStart(DateTime? v) => box.put(ExpenseStorageKeys.cachedTsStart, v);

  /// 获取已缓存的交易结束时间
  DateTime? get cachedTsEnd => box.get(ExpenseStorageKeys.cachedTsEnd);
  set cachedTsEnd(DateTime? v) => box.put(ExpenseStorageKeys.cachedTsEnd, v);
}
