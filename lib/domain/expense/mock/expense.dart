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
import 'package:kite/domain/expense/dao/expense.dart';
import 'package:kite/domain/expense/entity/expense.dart';

/// 测试数据
List<List<dynamic>> mockedData = [
  ['奉贤教工食堂一层9#', DateTime(2021, 12, 18, 12, 00, 03), 10.0, ExpenseType.canteen],
  ['六角亭勇阳超市2(192.168.16.39)', DateTime(2021, 12, 17, 12, 00, 03), 10.0, ExpenseType.store],
  ['奉贤教工食堂一层15#', DateTime(2021, 12, 16, 12, 00, 03), 10.0, ExpenseType.canteen],
  ['六角亭勇阳超市2(192.168.16.39)', DateTime(2021, 12, 17, 12, 00, 03), 10.0, ExpenseType.store],
  ['30号楼#12热水', DateTime(2021, 12, 15, 12, 00, 03), 10.0, ExpenseType.shower],
  ['30号楼#12热水', DateTime(2021, 10, 5, 12, 00, 03), 10.0, ExpenseType.shower],
  ['30号楼#12热水', DateTime(2021, 10, 4, 12, 00, 03), 10.0, ExpenseType.shower],
  ['30号楼#12热水', DateTime(2021, 9, 3, 12, 00, 03), 10.0, ExpenseType.shower],
  ['30号楼#12热水', DateTime(2021, 9, 2, 12, 00, 03), 10.0, ExpenseType.shower],
];

List classificationData = [
  {'label': 'canteen', 'money': 100, 'percentage': 0.8},
  {'label': 'canteen', 'money': 100, 'percentage': 0.2},
];

class ExpenseMock implements ExpenseRemoteDao {
  @override
  Future<OaExpensePage> getExpensePage(int pageNum, {DateTime? start, DateTime? end}) async {
    await Future.delayed(const Duration(microseconds: 300));
    return OaExpensePage()
      ..currentPage = 1
      ..total = 1
      ..records = mockedData
          .map(
            (e) => ExpenseRecord()
              ..username = '1234567890'
              ..name = 'abc'
              ..place = e[0]
              ..ts = e[1]
              ..amount = e[2]
              ..type = e[3],
          )
          .toList();
  }
}
