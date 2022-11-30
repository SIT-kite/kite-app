/*
 *
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
 *
 */

import 'package:kite/module/library/search/init.dart';
import 'package:kite/module/library/search/service/borrow.dart';
import '../../../init.dart';

void main() async {
  await init();
  await loginLibrary();
  final session = LibrarySearchInit.session;
  final service = LibraryBorrowService(session);
  test('get history borrow book list', () async {
    final result = await service.getHistoryBorrowBookList(1, 10);
    for (final item in result) {
      print(item);
    }
  });
  test('get current borrow book list', () async {
    final result = await service.getMyBorrowBookList(1, 10);
    for (final item in result) {
      print(item);
    }
  });
}
