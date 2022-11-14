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
import 'package:kite/module/expense2/entity/local.dart';
import 'package:kite/module/expense2/entity/page.dart';

import '../dao/local.dart';

class ExpenseStorage implements ExpenseLocalDao {
  @override
  void add(Transaction record) {
    // TODO: implement add
  }

  @override
  void addAll(Iterable<Transaction> records) {
    // TODO: implement addAll
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  // TODO: implement isEmpty
  bool get isEmpty => throw UnimplementedError();

  @override
  // TODO: implement last
  Transaction? get last => throw UnimplementedError();

  @override
  // TODO: implement pages
  CardBalance get pages => throw UnimplementedError();
}
