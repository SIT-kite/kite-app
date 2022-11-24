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

import 'package:kite/module/expense2/dao/getter.dart';
import 'package:kite/module/expense2/entity/local.dart';

import '../storage/local.dart';

class CachedExpenseGetDao implements ExpenseGetDao {
  final ExpenseGetDao remoteDao;
  final ExpenseStorage storage;
  CachedExpenseGetDao({
    required this.remoteDao,
    required this.storage,
  });

  Future<List<Transaction>> _fetchAndSave({
    required String studentID,
    required DateTime from,
    required DateTime to,
  }) async {
    final fetchedData = await remoteDao.fetch(studentID: studentID, from: from, to: to);
    storage.merge(records: fetchedData, start: from, end: to);
    return fetchedData;
  }

  @override
  Future<List<Transaction>> fetch({
    required String studentID,
    required DateTime from,
    required DateTime to,
    void Function(List<Transaction>)? onLocalQuery, // 本地查询完成
  }) async {
    queryInLocal() =>
        storage.getTransactionTsByRange(start: from, end: to).map((e) => storage.getTransactionByTs(e)!).toList();

    final cachedStart = storage.cachedTsStart;
    final cachedEnd = storage.cachedTsEnd;
    if (cachedStart == null && cachedEnd == null) {
      // 第一次获取数据
      onLocalQuery?.call([]);
      final result = await _fetchAndSave(studentID: studentID, from: from, to: to);
      return result;
    }

    onLocalQuery?.call(queryInLocal());
    if (to.isAfter(cachedEnd!)) await _fetchAndSave(studentID: studentID, from: cachedEnd, to: to);
    if (from.isBefore(cachedStart!)) await _fetchAndSave(studentID: studentID, from: from, to: cachedStart);

    return queryInLocal();
  }
}
