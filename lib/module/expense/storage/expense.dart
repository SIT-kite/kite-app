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
import '../using.dart';
import '../dao/expense.dart';
import '../entity/expense.dart';

class ExpenseLocalStorage implements ExpenseLocalDao {
  final Box<ExpenseRecord> box;

  const ExpenseLocalStorage(this.box);

  @override
  void add(ExpenseRecord record) {
    box.put(record.ts.hashCode, record);
  }

  @override
  void addAll(Iterable<ExpenseRecord> records) {
    final Map<dynamic, ExpenseRecord> map = {};
    for (final e in records) {
      map[e.ts.hashCode] = e;
    }
    box.putAll(map);
  }

  @override
  void deleteAll() {
    box.clear();
  }

  @override
  List<ExpenseRecord> getAllByTimeDesc() {
    var result = box.values.toList();
    result.sort((a, b) => b.ts.compareTo(a.ts));
    return result;
  }

  @override
  bool isExist(DateTime ts) {
    return box.get(ts.hashCode) == null;
  }

  @override
  ExpenseRecord? getLastOne() {
    int maxTimeStamp = 0;
    ExpenseRecord? result;
    for (final e in box.values) {
      if (e.ts.millisecondsSinceEpoch > maxTimeStamp) {
        maxTimeStamp = e.ts.millisecondsSinceEpoch;
        result = e;
      }
    }
    return result;
  }

  @override
  bool isEmpty() {
    return box.isEmpty;
  }
}
