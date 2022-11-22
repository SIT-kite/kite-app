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
import 'package:kite/module/expense2/entity/page.dart';

class ExpenseStorage {
  final Box<Map<String, dynamic>> box;
  ExpenseStorage(this.box);

  void add(Transaction record) {
    box.put(record.datetime.hashCode, record.toJson());
  }

  void addAll(Iterable<Transaction> records) {
    for (final e in records) {
      add(e);
    }
  }

  void clear() {
    box.clear();
  }

  bool get isEmpty => box.isEmpty;

  Transaction? get last {
    final list = box.values.map(Transaction.fromJson).toList();
    list.sort((a, b) => a.datetime.compareTo(b.datetime));
    if (list.isEmpty) return null;
    return list.last;
  }

  CardBalance get pages => throw UnimplementedError();
}
